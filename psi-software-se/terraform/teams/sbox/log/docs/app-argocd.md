ArgoCD
===

## Introduction
ArgoCD is a declarative, GitOps continuous delivery tool for Kubernetes.
This quick start guide will help you install and configure the ArgoCD and ArgoCD CLI client on a Linux system.

### Prerequisites
- A Linux-based operating system
- kubectl installed and configured
- Access to a Kubernetes cluster
- Admin privileges on the cluster
- Internet access to download the CLI tool

## Installation

Issue the following commands from the root folder of this project:

```bash
helm dep update 30_apps/argocd/argocd-install/
helm upgrade --install argocd 30_apps/argocd/argocd-install/ -n argocd --create-namespace
```

## Configuration

To update the password of an existing user, run the following script from the root folder of this project:

```bash
bin/set-argocd-password.sh
```

Generate an auth token if needed:

```bash
argocd account generate-token --account <username>
```

Now it is possible to log into ArgoCD as a new user with a password or generated token.

### Login to ArgoCD

ArgoCD should be accessible at: http://argocd.log.psi.de/login. The password for the `admin` and `psidev` account is available in KeePassXC.

## Create project

```
kubectl create -f 30_apps/argocd/argocd-projects/wms-mockup-project.yaml
```

## Create app

```
kubectl create -f 30_apps/argocd/argocd-apps/wms-mockup-app.yaml -n argocd
```

## Add new repository (manually) 

To add a new repository, log into `ArgoCD` and go to `Settings`->`Repositories` , then press `+ CONNECT REPO `

Using the CLI

```
argocd repo add <repository-url> --ssh-private-key-path <key-file-path>
```

## And new repository (configuration as code)

1. Prepare a `Secret` resource e.g. `devops-repo.yaml`

    ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
      name: devops-repository
      namespace: argocd
      labels:
        argocd.argoproj.io/secret-type: repository
    stringData:
        url: 'git@odin.internal.psicloud.de:devops/devops.git'
        sshPrivateKey: |
          -----BEGIN OPENSSH PRIVATE KEY-----
          ...
          -----END OPENSSH PRIVATE KEY-----
    ```
2. Convert `Secret` to `SealedSecret`

    ``` 
    kubeseal --controller-namespace sealed-secrets -f devops-repo.yaml -o yaml > devops-repo-ss.yaml
    ```
3. Add `SealedSecret` resource to `30_apps/argocd/argocd-repositories/devops-repo-ss.yaml`
4. Apply the Repository Configuration
    ```
    kubectl apply -f 30_apps/argocd/argocd-repositories/devops-repo-ss.yaml
    ```

ArgoCD cli client installation
===

## Installation
```bash
# Select desired version from https://github.com/argoproj/argo-cd/releases
ARGOCD_CLI_VERSION=v2.11.4
curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/${ARGOCD_CLI_VERSION}/argocd-linux-amd64 && \
    chmod +x /usr/local/bin/argocd
```
Check the version of the installed ArgoCD CLI to ensure it is installed correctly.
```bash
argocd version
```

```
argocd: v2.11.3+3f344d5
  BuildDate: 2024-06-06T09:27:36Z
  GitCommit: 3f344d54a4e0bbbb4313e1c19cfe1e544b162598
  GitTreeState: clean
  GoVersion: go1.21.10
  Compiler: gc
  Platform: linux/amd64
  ```

## Basic Usage
### Create a New Application
To create a new application in ArgoCD, you can use the following command.
Replace the placeholders with your specific values.

```bash
argocd app create <APP_NAME> \
    --repo <REPO_URL> \
    --path <APP_PATH> \
    --dest-server <DEST_SERVER> \
    --dest-namespace <DEST_NAMESPACE>
```
Another way is to use a prepared application manifest.

```bash
argocd app create -f wms-mockup-app.yaml
```

We can overwrite values used in the manifest.

```bash
argocd app create -f wms-mockup-app.yaml --name psiwms-2024-1 --dest-namespace psiwms-2024-1
```



### Sync an Application
To sync (deploy) an application, use the following command:

```bash
argocd app sync <APP_NAME>
```

### Check the Status of an Application
To get the current status of an application, use:

```bash
argocd app status <APP_NAME>
```

## Common Commands
### List Applications:

```bash
argocd app list
```
### Delete an Application:

```bash
argocd app delete <APP_NAME>
```
### Get Application Details:

```bash
argocd app get <APP_NAME>
```
### Roll Back an Application:

```bash
argocd app rollback <APP_NAME> <REVISION>
```

## Automatic Application Deployment with ArgoCD ApplicationSet controller.

Current configuration deploys ApplicationSet resource that is responsible for automatic Applications deployment that are defined in repository in `infrastructure/terraform/wms-tool-0/argocd/apps` directory. 

ApplicationSet is using `Git File Generator` to browse main branch's directory structure for `application.yaml` (name is case sensitive) files and generate Application manifests based on the content.
To create new deployment: 
1) create new directory: eg. `infrastructure/terraform/wms-tool-0/argocd/apps/new-awsome-app` 
1) create new file called 'application.yaml' in this directory: eg. `infrastructure/terraform/wms-tool-0/argocd/apps/new-awsome-app/application.yaml`
1) merge to main 

Application will be deployed and maintained by ArgoCD from now on.

For security reasons application name, namespace and argocd project defined in `application.yaml` are overriden by generator:
* application name => deployment directory name (eg. `new-awsome-app`)
* destination.namespace => deployment directory name  (eg. `new-awsome-app`)
* destination.server => https://kubernetes.default.svc
* argocd project => default

## Additional Resources
For more detailed information, refer to the official:
[Official Documentation](https://argo-cd.readthedocs.io/en/stable/)

ApplicationSet Documentation:
[Security](https://argo-cd.readthedocs.io/en/latest/operator-manual/applicationset/Security/#:~:text=before%20using%20it.-,Only%20admins%20may%20create/update/delete%20ApplicationSets,-%C2%B6) and 
[Repository Credentials Restrictions](https://argo-cd.readthedocs.io/en/latest/operator-manual/applicationset/Generators-Git/#:~:text=If%20your%20ApplicationSets%20uses%20a%20repository%20where%20you%20need%20credentials%20to%20be%20able%20to%20access%20it%2C%20you%20need%20to%20add%20the%20repository%20as%20a%20%22non%20project%20scoped%22%20repository.)

