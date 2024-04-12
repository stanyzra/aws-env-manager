import re
import boto3


def get_ecs_clusters(ecs_client):
    response = ecs_client.list_clusters()
    clusters = {"cluster_names": [], "project_type": "back"}

    for cluster_arns in response["clusterArns"]:
        clusters["cluster_names"].append(cluster_arns.split("/")[-1])

    return clusters


def get_amplify_apps(amplify_client):
    response = amplify_client.list_apps()
    apps = {
        "apps": [],
        "project_type": "front",
    }

    for app in response["apps"]:
        apps["apps"].append({"app_name": app["name"], "app_id": app["appId"]})

    return apps


def get_largest_array_len(env_infos):
    array_len = 0
    for key in env_infos:
        actual_array_len = len(env_infos[key])
        if type(env_infos[key]) == list:
            array_len = actual_array_len if actual_array_len > array_len else array_len
    return array_len


def parse_branch_td_name(branch):
    if branch == "production":
        return "prod"
    elif branch == "development":
        return "dev"
    return branch


def find_dict_by_key(dict_list, key, value):
    for i, d in enumerate(dict_list):
        if d.get(key) == value:
            return i
    return -1


def get_td_name(project, branch):
    match = re.search(r".*api", project)
    if match:
        td_branch_name = parse_branch_td_name(branch)
        td_name = f"{match.group(0)}-{td_branch_name}-td"
        return td_name
    else:
        return None


def get_env_info_choice(prompt, choices):
    print(prompt)
    [print(f"{i + 1} - {choice}") for i, choice in enumerate(choices)]
    user_input = input()
    if user_input == "":
        return None, None
    if not user_input.isdigit() or int(user_input) not in range(1, len(choices) + 1):
        print("[ERROR] Invalid option")
        return None, None
    return choices[int(user_input) - 1], int(user_input) - 1


def mask_credential(credential):
    return "*" * (len(credential) - 4) + credential[-4:]


def get_input(prompt, default_value):
    print(
        f"{prompt} [{'not provided' if default_value is None else f'{mask_credential(default_value)}'}]: "
    )
    user_input = input().strip()
    if not user_input and default_value is None:
        print(f"[ERROR] Must provide a {prompt.lower()}")
        exit()
    return user_input if user_input else default_value


def get_ssm_parameter(parameter_name, ssm):
    parameter = ssm.get_parameter(Name=parameter_name, WithDecryption=True)
    return parameter["Parameter"]["Value"]


def get_app_id_from_arn(arn):
    match = re.search(r"apps/(.*?)/", arn)
    if match:
        return match.group(1)
    return None
