# LOG: Infrastructure as Code

## How to prepare development environment

* It is recommended to use a Dev Container which definition is provided in this repository (see [.devcontainer/devcontainer.json](.devcontainer/devcontainer.json))
* For more details, visit [this page on Confluence](https://intranet-psise.atlassian.net/wiki/x/f3ERAw)

## How to authenticate to GCP

```shell
gcloud auth login --no-launch-browser
gcloud config set project psi-de-0-sandbox-log
# additional authentication required to work with terraform
gcloud auth application-default login --no-launch-browser
```

## How to work with terraform

* Initialize the environment:
    ```shell
    terraform init
    ```
* Preview changes:
    ```shell
    terraform plan -lock=false
    ```
* Use modules from the [common repository](https://gitlab.com/psi-software-se/terraform/modules):
    ```hcl
    module "bucket" {
        source = "git@gitlab.com:psi-software-se/terraform/modules.git//gcs?ref=stable"
        # ...
    }
    ```
  
Also see:
* [Example recipes on Confluence](https://intranet-psise.atlassian.net/wiki/x/zXERAw)
* [Official documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs) of the terraform Google provider

## How to locally access images in Artifact Registry

```shell
gcloud auth configure-docker [[LOCATION]]-docker.pkg.dev
docker pull [[LOCATION]]-docker.pkg.dev/[[PRJ_NAME]]/[[REGISTRY]]/[[IMAGE_NAME]]:[[TAG]]
# example:
gcloud auth configure-docker europe-west3-docker.pkg.dev
docker pull nginx
docker tag nginx:latest europe-west3-docker.pkg.dev/psi-de-0-sandbox-log/container-images/nginx:latest
docker push europe-west3-docker.pkg.dev/psi-de-0-sandbox-log/container-images/nginx:latest
```

## How to locally access GKE cluster

* add GKE cluster to local `.kube/config`
    ```shell
    gcloud container clusters get-credentials [[CLUSTER_NAME]] --region europe-west3 --project [[PROJECT_ID]]
    # example:
    gcloud container clusters get-credentials gke-sbox-log-1 --region europe-west3 --project psi-de-0-sandbox-log
    ```

* verify by making example `kubectl` calls
    ```shell
    kubectl cluster-info
    # start nginx:
    kubectl run nginx --image=europe-west3-docker.pkg.dev/psi-de-0-sandbox-log/container-images/nginx --port=80
    # forward port:
    kubectl port-forward nginx 8080:80
    curl http://localhost:8080
    kubectl delete pod nginx
    ```
