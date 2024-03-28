import os
from utils import *
import argparse
import boto3
import boto3.session
from utils import *
import configparser
from botocore.exceptions import ClientError


def parser_configuration(project_choices, branch_choices, type_choices):
    formatter = lambda prog: argparse.RawTextHelpFormatter(prog, max_help_position=100)
    # max_help_position >= max(len(param.name)+len(param.metavar) for param in params)

    parser = argparse.ArgumentParser(
        description="Manage environment variables for Collection",
        formatter_class=formatter,
    )

    parser.add_argument(
        "-p, --project",
        help="Collection project: \n"
        "   * app-memorial-collection-v2\n"
        "   * app-biblioteca-collection-v2\n"
        "   * collection-front-end-v2.1\n"
        "   * collection-api-ecs-v2\n"
        "   * gollection-elastic-api",
        type=str,
        dest="project",
        metavar="",
        choices=project_choices,
    )

    parser.add_argument(
        "-b, --branch",
        help="project environment/branch: \n"
        "   prod - production\n"
        "   beta - beta\n"
        "   hg - homolog\n"
        "   dev - dev",
        type=str,
        dest="branch",
        metavar="",
        choices=branch_choices,
    )

    parser.add_argument(
        "-t, --type",
        help="env variable type: \n"
        "   normal - Normal string type\n"
        "   secret - SecureString type",
        type=str,
        metavar="",
        dest="type",
        choices=type_choices,
    )

    parser.add_argument(
        "option",
        help="Option: \n"
        "   new - create (or update) an env\n"
        "   remove - remove an env\n"
        "   configure - set the credentials for your AWS account",
        type=str,
        choices=["new", "remove", "configure"],
    )

    return parser.parse_args()


def manage_ecs_task_definition(env_infos, ecs_client, option, env_already_exists):
    largest_array_len = get_largest_array_len(env_infos)
    cont = 0
    tds = {
        "production": [],
        "homolog": [],
        "development": [],
    }
    while cont < largest_array_len:
        if env_already_exists[cont] and option == "new":
            cont += 1
            continue
        td_name = get_td_name(env_infos["project"], env_infos["branches"][cont])

        latest_td = ecs_client.describe_task_definition(
            taskDefinition=td_name,
        )

        env_path = "/{}/{}/{}".format(
            env_infos["branches"][cont],
            env_infos["env_types"][cont],
            env_infos["env_names"][cont],
        )

        remove_args = [
            "compatibilities",
            "registeredAt",
            "registeredBy",
            "status",
            "revision",
            "taskDefinitionArn",
            "requiresAttributes",
        ]
        for arg in remove_args:
            latest_td["taskDefinition"].pop(arg)

        if len(tds[env_infos["branches"][cont]]) == 0:
            tds[env_infos["branches"][cont]] = latest_td["taskDefinition"]

        if option == "new":
            tds[env_infos["branches"][cont]]["containerDefinitions"][0][
                "secrets"
            ].append({"name": env_infos["env_names"][cont], "valueFrom": env_path})
        elif option == "remove":
            index = find_dict_by_key(
                tds[env_infos["branches"][cont]]["containerDefinitions"][0]["secrets"],
                "name",
                env_infos["env_names"][cont],
            )

            tds[env_infos["branches"][cont]]["containerDefinitions"][0]["secrets"].pop(
                index
            )

        cont += 1

    for branch in tds:
        if len(tds[branch]):
            ecs_client.register_task_definition(**tds[branch])


def manage_amplify_envs(env_infos, app_id, amplify_client, option):
    cont = 0
    largest_array_len = get_largest_array_len(env_infos)
    app_branches_to_update = {
        "production": {},
        "homolog": {},
        "development": {},
    }

    while cont < largest_array_len:
        if len(app_branches_to_update[env_infos["branches"][cont]]) == 0:
            app_branches_to_update[env_infos["branches"][cont]] = (
                amplify_client.get_branch(
                    appId=app_id, branchName=env_infos["branches"][cont]
                )
            )

        if option == "new":
            app_branches_to_update[env_infos["branches"][cont]]["branch"][
                "environmentVariables"
            ][env_infos["env_names"][cont]] = env_infos["env_values"][cont]
        elif option == "remove":
            if (
                env_infos["env_names"][cont]
                in app_branches_to_update[env_infos["branches"][cont]]["branch"][
                    "environmentVariables"
                ]
            ):
                del app_branches_to_update[env_infos["branches"][cont]]["branch"][
                    "environmentVariables"
                ][env_infos["env_names"][cont]]
            else:
                print(
                    "[ERROR] Environment variable '{}' doesn't exist for project '{}' in branch '{}'".format(
                        env_infos["env_names"][cont],
                        app_id,
                        env_infos["branches"][cont],
                    )
                )
        cont += 1

    for key in app_branches_to_update:
        if bool(app_branches_to_update[key]):
            app_id = get_app_id_from_arn(
                app_branches_to_update[key]["branch"]["branchArn"]
            )

            amplify_client.update_branch(
                appId=app_id,
                branchName=app_branches_to_update[key]["branch"]["branchName"],
                environmentVariables=app_branches_to_update[key]["branch"][
                    "environmentVariables"
                ],
            )


def manage_ssm_envs(env_infos, ssm_client, option):
    cont = 0
    env_already_exists = []
    largest_array_len = get_largest_array_len(env_infos)

    while cont < largest_array_len:
        if (
            len(env_infos["branches"]) == largest_array_len
            and len(env_infos["env_types"]) == largest_array_len
            and len(env_infos["env_names"]) == largest_array_len
            and (
                len(env_infos["env_values"]) == largest_array_len
                and option == "new"
                or option == "remove"
            )
        ):
            env_path = "/{}/{}/{}".format(
                env_infos["branches"][cont],
                env_infos["env_types"][cont],
                env_infos["env_names"][cont],
            )

            env_type = (
                "SecureString" if env_infos["env_types"][cont] == "secret" else "String"
            )

            try:
                get_ssm_parameter(env_path)
                env_already_exists.append(True)
            except ClientError as error:
                if (
                    error.response["Error"]["Code"] == "ParameterNotFound"
                    and option == "new"
                ):
                    env_already_exists.append(False)
                elif (
                    error.response["Error"]["Code"] == "ParameterNotFound"
                    and option == "remove"
                ):
                    print(f"[ERROR] parameter '{env_path}' doesn't exist in SSM")
                    env_already_exists.append(False)
                else:
                    print("[ERROR] unknow error: ", error)
            try:
                if option == "new":
                    print("Uploading/updating env: {}".format(env_path))
                    ssm_client.put_parameter(
                        Name=env_path,
                        Value=env_infos["env_values"][cont],
                        Type=env_type,
                        Overwrite=True,
                        Tier="Standard",
                    )

                elif option == "remove" and env_already_exists[cont]:
                    print("Removing env: {}".format(env_path))
                    ssm_client.delete_parameter(
                        Name=env_path,
                    )
            except ClientError as error:
                print(error)
                exit()
            cont += 1
        else:
            print("[ERROR] Invalid parameters, aborting")
            exit()
    return env_already_exists


def configure_credentials(
    aws_access_key_id=None, aws_secret_access_key=None, region_name=None
):
    aws_access_key_id = get_input("AWS Access Key ID", aws_access_key_id)
    aws_secret_access_key = get_input("AWS Secret Access Key ID", aws_secret_access_key)
    region_name = get_input("AWS Region Name", region_name)

    return aws_access_key_id, aws_secret_access_key, region_name


def save_credentials(
    aws_access_key_id, aws_secret_access_key, region_name, config_path, config_file_name
):
    config = configparser.ConfigParser()
    config["DEFAULT"] = {
        "aws_access_key_id": aws_access_key_id,
        "aws_secret_access_key": aws_secret_access_key,
        "region": region_name,
    }

    if not os.path.isfile(f"{config_path}/{config_file_name}"):
        os.makedirs(config_path)

    with open(f"{config_path}/{config_file_name}", "w") as configfile:
        config.write(configfile)


def get_environment_infos(
    project_choices, project_types, branch_choices, type_choices, option, apps
):
    env_to_upload = {
        "project": "",
        "branches": [],
        "env_types": [],
        "env_names": [],
        "env_values": [],
    }

    project, _ = get_env_info_choice("Insert project: ", project_choices)
    if project is None:
        return None, None
    env_to_upload["project"] = project
    project_type = project_types[project]
    app_id = (
        None
        if project_type != "front"
        else apps[find_dict_by_key(apps, "app_name", project)]["app_id"]
    )

    while True:
        branch, _ = get_env_info_choice(
            "Insert environment/branch (enter to stop): ", branch_choices
        )
        if branch is None:
            break
        env_to_upload["branches"].append(branch)

        if project_type != "front":
            env_type, _ = get_env_info_choice("Informe o tipo da env: ", type_choices)
            if env_type is None:
                break
            env_to_upload["env_types"].append(env_type)

        print("Insert env name: ")
        user_input = input()
        if user_input == "":
            break

        env_name = user_input
        env_to_upload["env_names"].append(env_name)

        if option == "new":
            print("Insert env value: ")
            user_input = input()
            if user_input == "":
                break
            env_value = user_input
            env_to_upload["env_values"].append(env_value)

    return env_to_upload, project_type, app_id


if __name__ == "__main__":
    home_dir = os.path.expanduser("~")
    config_path = f"{home_dir}/.env_manager"
    config_file_name = "config"
    is_configured = False
    aws_access_key_id = None
    aws_secret_access_key = None
    region_name = None
    project_choices = []

    if os.path.isfile(f"{config_path}/{config_file_name}"):
        config = configparser.ConfigParser()
        config.read(f"{config_path}/{config_file_name}")

        aws_access_key_id = config["DEFAULT"]["aws_access_key_id"]
        aws_secret_access_key = config["DEFAULT"]["aws_secret_access_key"]
        region_name = config["DEFAULT"]["region"]

        my_session = boto3.session.Session(
            aws_access_key_id=aws_access_key_id,
            aws_secret_access_key=aws_secret_access_key,
            region_name=region_name,
        )

        ecs = my_session.client("ecs")
        ssm = my_session.client("ssm")
        amplify = my_session.client("amplify")

        ecs_clusters = get_ecs_clusters(ecs)
        amplify_apps = get_amplify_apps(amplify)

        project_types = {
            name: ecs_clusters["project_type"] for name in ecs_clusters["cluster_names"]
        }
        project_types.update(
            {
                app["app_name"]: amplify_apps["project_type"]
                for app in amplify_apps["apps"]
            }
        )

        project_choices = sorted(project_types.keys())

        is_configured = True

    branch_choices = ["production", "homolog", "development"]
    type_choices = ["normal", "secret"]
    args = parser_configuration(project_choices, branch_choices, type_choices)

    if is_configured and args.option == "new":
        env_infos, project_type, app_id = get_environment_infos(
            project_choices,
            project_types,
            branch_choices,
            type_choices,
            args.option,
            amplify_apps["apps"],
        )
        if project_type == "back":
            env_already_exists = manage_ssm_envs(env_infos, ssm, args.option)
            manage_ecs_task_definition(env_infos, ecs, args.option, env_already_exists)
        else:
            manage_amplify_envs(env_infos, app_id, amplify, args.option)
    elif is_configured and args.option == "remove":
        env_infos, project_type, app_id = get_environment_infos(
            project_choices,
            project_types,
            branch_choices,
            type_choices,
            args.option,
            amplify_apps["apps"],
        )
        if project_type == "back":
            env_already_exists = manage_ssm_envs(env_infos, ssm, args.option)
            manage_ecs_task_definition(env_infos, ecs, args.option, env_already_exists)
        else:
            manage_amplify_envs(env_infos, app_id, amplify, args.option)
    elif args.option == "configure":
        aws_access_key_id, aws_secret_access_key, region_name = configure_credentials(
            aws_access_key_id, aws_secret_access_key, region_name
        )

        save_credentials(
            aws_access_key_id,
            aws_secret_access_key,
            region_name,
            config_path,
            config_file_name,
        )
    else:
        print("[ERROR] Credentials not configured")
