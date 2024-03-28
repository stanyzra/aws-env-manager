
# Env manager

A environment variable manager for AWS Amplify and ECS, initially designed for Collection

## Installation (NOT FINISHIED YET)

The env manager can be installed with Brew using the following command:

```bash
$ brew install env-manager
```

## Configuring

To actual use the env manager, you must configure your AWS credentials first. Theses credentials must have permission for Amplify, ECS and SSM, since the software need to list, create, update and delete resources from these services.

To configure, run the following command:

```bash
$ env-manager configure
```