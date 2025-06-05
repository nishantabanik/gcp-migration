# agro: Infrastructure as a Code

[![Open in Dev Container](https://img.shields.io/static/v1?label=Dev%20Containers&message=Open%20in%20Dev%20Container&color=green)](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=git@gitlab.com:psi-software-se/terraform/teams/sbox/agro.git)

## How to prepare development environment

* it is recommended to use a Dev Container which definition is provided in this repository (see [.devcontainer/devcontainer.json](.devcontainer/devcontainer.json))
* alternatively all necessary tools can be installed locally
* for more details visit [this page on Confluence](https://intranet-psise.atlassian.net/wiki/x/f3ERAw)

## How to authenticate to GCP

```shell
gcloud auth login --no-launch-browser --update-adc
```

## How to work with terraform

* initiate environment

    ```shell
    terraform init
    ```

* see the plan

    ```shell
    terraform plan -lock=false
    ```

* use the modules from the [common repository](https://gitlab.com/psi-software-se/terraform/modules)

    ```hcl
    # example
    module "bucket" {
        source = "git@gitlab.com:psi-software-se/terraform/modules.git//gcs?ref=stable"
        # ...
    }
    ```

* see [example recipes on Confluence](https://intranet-psise.atlassian.net/wiki/x/zXERAw)
* see the [official documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs) of the terraform Google provider

## How to locally access images in Artifact Registry

```shell
gcloud auth configure-docker [[LOCATION]]-docker.pkg.dev
docker pull [[LOCATION]]-docker.pkg.dev/[[PRJ_NAME]]/[[REGISTRY]]/[[IMAGE_NAME]]:[[TAG]]
# example:
gcloud auth configure-docker europe-west3-docker.pkg.dev
docker pull nginx
docker tag nginx:latest europe-west3-docker.pkg.dev/psi-de-0-sandbox-agro/container-images/nginx:latest
docker push europe-west3-docker.pkg.dev/psi-de-0-sandbox-agro/container-images/nginx:latest
```

## How to locally access GKE cluster

* add GKE cluster to local `.kube/config`

    ```shell
    gcloud container clusters get-credentials [[CLUSTER_NAME]] --region europe-west3 --project [[PROJECT_ID]]
    # example:
    gcloud container clusters get-credentials gke-sandbox-agro-1 --region europe-west3 --project psi-de-0-sandbox-agro
    ```

* verify by making example `kubectl` calls

    ```shell
    kubectl cluster-info
    # start nginx:
    kubectl run nginx --image=europe-west3-docker.pkg.dev/psi-de-0-sandbox-agro/container-images/nginx --port=80
    # forward port:
    kubectl port-forward nginx 8080:80
    curl http://localhost:8080
    kubectl delete pod nginx
    ```
