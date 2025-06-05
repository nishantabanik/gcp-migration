# ArgoCD ApplicationSet - autodeploy apps

This document describes the purpose and structure of the `team-repos` ApplicationSet, which dynamically generates ArgoCD Applications from repositories in a specific GitLab group. It is intended to support automated deployment workflows across both `main` and `feature` branches.

# Purpose
The `team-repos` ApplicationSet enables:

- Automatic discovery of repositories and branches in a defined GitLab group.
- Creation of Argo CD Applications for any repository that includes a deployment configuration under `deploy` directory.
- Support for both stable `main` and development `feature` branches.
- Flexible filtering based on paths and branch naming conventions.

# How to deploy app
To deploy an application automatically, create a new directory under `deploy/` in your repository and place a valid Helm chart/manifest inside new created folder and add `config.json` file to configure deploying.

config.json
```
{
    "deployOnFeatureBranch": false
}
```

### Main Branch Deployments:
- By default, applications are deployed from the main branch using directories like `deploy/new-app`.

### Feature Branch Deployments:
- To deploy from a feature branch change `config.json` file and adjust parameter `deployOnFeatureBranch`, set to `true` if you want to deploy app in feature branch. It will automatically detect the configuration after commit.

# Example

```
repo-root
├── README.md
├── some-code
├── deploy
│   ├── app1
│       ├── Chart.yaml
│       ├── values.yaml
│       ├── templates
│       ├── config.json
│   ├── app2
│       ├── kustomization.yaml
│       ├── config.json
```

