Sealed Secrets
===

## Installation
```
helm dep update 20_k8s/sealed-secrets/
```
```
helm upgrade --install sealed-secrets-controller 20_k8s/sealed-secrets/ -n sealed-secrets --create-namespace
```

## And new Sealed Secret

1. You must have `kubeseal CLI` installed locally and be connected to the cluster
2. Prepare a `Secret` resource e.g. `example-secret.yaml`

    ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
    name: mysecret
    namespace: mynamespace
    type: Opaque
    data:
    username: bXl1c2VybmFtZQ==
    password: bXlwYXNzd29yZA==
    ```
3. Convert `Secret` to `SealedSecret`

    ``` 
    kubeseal --controller-namespace sealed-secrets --controller-name sealed-secrets -f example-secret.yaml -o yaml > example-secret-ss.yaml
    ```
4. Apply the `Sealed Secret`
    ```
    kubectl apply -f ./example-secret-ss.yaml
    ```

## Retrieve Sealed Secret

1. You must have `kubeseal CLI` installed locally and be connected to the cluster
2. Fetch the Controller's Private Key: 

    ```
    kubectl get secret -n sealed-secrets -l sealedsecrets.bitnami.com/sealed-secrets-key -o yaml > sealed-secrets-key.yaml
    ``` 
3. Decrypt the `Sealed Secret`: 

    ```
    kubeseal -f ./example-secret-ss.yaml --recovery-unseal --recovery-private-key sealed-secrets-key.yaml -o yaml
    ```
