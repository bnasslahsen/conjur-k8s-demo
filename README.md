# Demo project for Conjur integration with OpenShift/Kubernetes
A demo application creating using the Spring Framework. 
This application requires access to an H2 database.

## Installation
After cloning this repository.

1. Get the docker image
An image is already available in dockerhub: `docker.io/bnasslahsen/conjur-k8s-demo`
If you need to build the image:
```shell
podman build --arch=amd64 -f docker/initial/Dockerfile -t conjur-k8s-demo:latest .
podman tag conjur-k8s-demo:latest conjur-k8s-demo:1.0
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
- Option 3:  With Summon as Init Container
For this option, you will have to add summon utility to the image. 
An image is already available in dockerhub: `docker.io/bnasslahsen/conjur-summon-k8s-demo`
If you need to build the image:
```shell
podman build --arch=amd64 -f docker/summon/Dockerfile -t conjur-summon-k8s-demo:latest .
podman tag conjur-summon-k8s-demo:latest conjur-summon-k8s-demo:1.0
```

  - Then edit the `kubernetes/summon-init/.env` and set the values depending on your target environment.
  - Run the following commands:
```shell
cd kubernetes/summon-init
./deploy-app.sh
```

- Option 4:  With Summon as Sidecar Container
  - Edit the `kubernetes/summon-sidecar/.env` and set the values depending on your target environment.
  - Run the following commands:
```shell
cd kubernetes/summon-sidecar
./deploy-app.sh
```

- Option 5:  With Secretless Broker
For this option, you will have to use a supported Database (For example postgresql)
An image is already available in dockerhub: `docker.io/bnasslahsen/conjur-secretless-k8s-demo`
If you need to build the image:
```shell
podman build --arch=amd64 -f docker/secretless/Dockerfile -t conjur-secretless-k8s-demo:latest .
podman tag conjur-secretless-k8s-demo:latest conjur-secretless-k8s-demo:1.0
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
