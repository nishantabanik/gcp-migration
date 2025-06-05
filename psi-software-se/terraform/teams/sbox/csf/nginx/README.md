# Image migration to the GCP

## Identifying the images used by Helm Chart

```bash
helm template ingress-nginx ingress-nginx/ingress-nginx --version 4.12.0 | grep image
```

## Retagging and pushing images to GCP artifact registry

```bash
docker pull registry.k8s.io/ingress-nginx/controller:v1.12.0@sha256:e6b8de175acda6ca913891f0f727bca4527e797d52688cbe9fec9040d6f6b6fa
docker pull registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.5.0@sha256:aaafd456bda110628b2d4ca6296f38731a3aaf0bf7581efae824a41c770a8fc4

docker tag registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.5.0@sha256:aaafd456bda110628b2d4ca6296f38731a3aaf0bf7581efae824a41c770a8fc4 europe-west3-docker.pkg.dev/psi-de-0-sbox-csf/artifacts/ingress-nginx/kube-webhook-certgen:v1.5.0
docker push  europe-west3-docker.pkg.dev/psi-de-0-sbox-csf/artifacts/ingress-nginx/kube-webhook-certgen:v1.5.0

docker tag registry.k8s.io/ingress-nginx/controller:v1.12.0@sha256:e6b8de175acda6ca913891f0f727bca4527e797d52688cbe9fec9040d6f6b6fa europe-west3-docker.pkg.dev/psi-de-0-sbox-csf/artifacts/ingress-nginx/controller:v1.12.0
docker push europe-west3-docker.pkg.dev/psi-de-0-sbox-csf/artifacts/ingress-nginx/controller:v1.12.0
```

## Run the chart

```bash
helm install ingress-nginx ingress-nginx/ingress-nginx --version 4.12.0 \
-n ingress-nginx --create-namespace -f gke-1-ingress-nginx-values.yaml
```
