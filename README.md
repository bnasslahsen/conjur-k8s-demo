# Demo project for Conjur integration with OpenShift/Kubernetes
A demo application creating using the Spring Framework. 
This application requires access to an H2 database.

## Installation
After cloning this repository.

1. Publish docker image
- REGISTRY: Is your registry URL
```shell
  podman build --arch=amd64 -f docker/Dockerfile -t conjur-k8s-demo:1.0 .
  podman tag conjur-k8s-demo:1.0 conjur-k8s-demo:latest
  podman push "${REGISTRY}/conjur-k8s-demo:latest"
```

2. Load the Conjur policies
```shell
cd policies
# If you are not using the Vault synchronizer
./load-policies-without-syncrhronizer.sh
# If you are using the Vault synchronizer
./load-policies-with-syncrhronizer.sh
```

3. Deploy your application to k8s/Openshift

- Option 0:  With k8s/Openshift secrets
    - Edit the `kubernetes/basic-k8s-secrets/.env` and set the values depending on your target environment.
    - Run the following commands:
```shell
cd kubernetes/basic-k8s-secrets
./deploy-app.sh
```

- Option 1:  With Secrets Provider for Kubernetes As Init Container
    - Edit the `kubernetes/secrets-provider-for-k8s-init/.env` and set the values depending on your target environment.
    - Run the following commands:
```shell
cd kubernetes/secrets-provider-for-k8s-init
./deploy-app.sh
```

- Option 2: With Secrets Provider for Kubernetes As Sidecar Container
    - Edit the `kubernetes/secrets-provider-for-k8s-sidecar/.env` and set the values depending on your target environment.
    - Run the following commands:
```shell
cd kubernetes/secrets-provider-for-k8s-sidecar
./deploy-app.sh
```

## Running the pet-store demo

### Routes
The demo application mocks a pet store service which controls an inventory of pets in a persistent database. The following routes are exposed:

---
`GET` `/pets`  
List all pets in inventory
##### Returns
`200`  
An array of pets in the response body
```
[
  {
    "name": "Scooter"
  },
  {
    "name": "Sparky"
  }
]
```

---
`POST` `/pet`  
Add a pet to the inventory
##### Request
###### Headers
`Content-Type: application/json`
###### Body
```
{
  "name": "Scooter"
}
```
##### Returns
`201`

---
`GET` `/pet/{id}`  
Retrieve information on a pet
##### Returns
`404`
`200`
```
{
  "id": 1
  "name": "Scooter"
}
```
---
`DELETE` `/pet/{id}`  
Remove a pet from inventory
##### Returns
`404`
`200`

---
`GET` `/vulnerable`
Return a JSON representation of all environment variables that
the app knows about
##### Returns
`200`

# Contributing

To learn more about contributing to this repository, please see [CONTRIBUTING.md](CONTRIBUTING.md).

# License

The Pet Store demo app is licensed under Apache License 2.0 - see [`LICENSE.md`](LICENSE.md) for more details.
