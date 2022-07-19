# Demo project for Conjur integration with OpenShift/Kubernetes
A demo application creating using the Spring Framework. 
This application requires access to an H2 database.

## Pre-requisites
- podman
- kubectl
- conjur-cli

## Kubernetes / OCP Setup
cd  policies/k8s-authenticator
./load-policies.sh
cd  policies/follower
./load-policies.sh
cd  policies/app
./load-policies-without-syncrhronizer.sh
# Or load-policies-with-syncrhronizer.sh
cd initial-setup
./1-create-kubernetes-resources.sh
./2-configure-conjur-for-k8s.sh
# Or ./2-configure-conjur-for-ocp.sh
./3-configure-follower.sh
# Or ./3-configure-ocp-follower.sh
./4-configure-app.sh

## Building the Docker images (optional)
Note: All the docker images are already available in dockerhub repository: 
- `docker.io/bnasslahsen/conjur-k8s-demo`
- `docker.io/bnasslahsen/conjur-summon-k8s-demo`
- `docker.io/bnasslahsen/conjur-secretless-k8s-demo`
- `docker.io/bnasslahsen/conjur-springboot-k8s-demo`

If you don't have access to dockerhub and you need to build the images then, after cloning this repository:

1. Build the `conjur-k8s-demo`

```shell
podman run -it --rm -v $HOME/.m2:/root/.m2 -v "$(pwd)":/build -w /build maven mvn clean package
podman build --arch=amd64 -f docker/initial/Dockerfile -t conjur-k8s-demo:latest .
podman tag conjur-k8s-demo:latest conjur-k8s-demo:1.0
```

2. Build the `conjur-summon-k8s-demo`

```shell
podman run -it --rm -v $HOME/.m2:/root/.m2 -v "$(pwd)":/build -w /build maven mvn clean package
podman build --arch=amd64 -f docker/summon/Dockerfile -t conjur-summon-k8s-demo:latest .
podman tag conjur-summon-k8s-demo:latest conjur-summon-k8s-demo:1.0
```

3. Build the `conjur-secretless-k8s-demo`

```shell
podman run -it --rm -v $HOME/.m2:/root/.m2 -v "$(pwd)":/build -w /build maven mvn -Ppostgresql clean package
podman build --arch=amd64 -f docker/secretless/Dockerfile -t conjur-secretless-k8s-demo:latest .
podman tag conjur-secretless-k8s-demo:latest conjur-secretless-k8s-demo:1.0
```

4. Build the `conjur-springboot-k8s-demo`

```shell
podman run -it --rm -v $HOME/.m2:/root/.m2 -v "$(pwd)":/build -w /build maven mvn -Pconjur clean package
podman build --arch=amd64 -f docker/springboot/Dockerfile -t conjur-springboot-k8s-demo:latest .
podman tag conjur-springboot-k8s-demo:latest conjur-springboot-k8s-demo:1.0
```

## Applying the Conjur policies
```shell
cd policies
# If you are not using the Vault synchronizer
./load-policies-without-syncrhronizer.sh
# If you are using the Vault synchronizer
./load-policies-with-syncrhronizer.sh
```

## Deploy your application to k8s/Openshift

- Option 0:  With k8s/Openshift secrets
    - Edit the `k8s-use-cases/basic-k8s-secrets/.env` and set the values depending on your target environment.
    - Run the following commands:
```shell
cd k8s-use-cases/basic-k8s-secrets
./deploy-app.sh
```

- Option 1:  With Secrets Provider for Kubernetes As Init Container
    - Edit the `k8s-use-cases/secrets-provider-for-k8s-init/.env` and set the values depending on your target environment.
    - Run the following commands:
```shell
cd k8s-use-cases/secrets-provider-for-k8s-init
./deploy-app.sh
```

- Option 2: With Secrets Provider for Kubernetes As Sidecar Container
    - Edit the `k8s-use-cases/secrets-provider-for-k8s-sidecar/.env` and set the values depending on your target environment.
    - Run the following commands:
```shell
cd k8s-use-cases/secrets-provider-for-k8s-sidecar
./deploy-app.sh
```
- Option 3:  With Summon as Init Container
  - Edit the `k8s-use-cases/summon-init/.env` and set the values depending on your target environment.
  - Run the following commands:
```shell
cd k8s-use-cases/summon-init
./deploy-app.sh
```

- Option 4:  With Summon as Sidecar Container
  - Edit the `k8s-use-cases/summon-sidecar/.env` and set the values depending on your target environment.
  - Run the following commands:
```shell
cd k8s-use-cases/summon-sidecar
./deploy-app.sh
```

- Option 5:  With Secretless Broker
  - Edit the `k8s-use-cases/secretless/.env` and set the values depending on your target environment.
  - Run the following commands:
```shell
cd k8s-use-cases/secretless
./deploy-app.sh
```

- Option 6:  With Spring Boot
  - Edit the `k8s-use-cases/springboot/.env` and set the values depending on your target environment.
  - Run the following commands:
```shell
cd k8s-use-cases/springboot
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

# License

The Pet Store demo app is licensed under Apache License 2.0 - see [`LICENSE.md`](LICENSE.md) for more details.
