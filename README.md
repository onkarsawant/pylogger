# pylogger
Python Flask logger Kubernetes application 



------------------------------
## Minikube installation 
------------------------------

https://minikube.sigs.k8s.io/docs/start/

$ minikube start --driver=docker


------------------------------
## Deploy using Terraform 
------------------------------

Installing terraform : https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

$ git clone https://github.com/onkarsawant/pylogger.git
$ cd pylogger/terraform 

# Initialize Terraform configuration and download necessary plugins required by the configuration
$ terraform init

# Check for any syntax errors or other issues
$ terraform validate 

# Check what changes Terraform will make to your infrastructure 
$ terraform plan 

# Apply changes and provision or modify your infrastructure
$ terraform apply 

# To cleanup the deployed infrastructure 
$ terraform destroy 


-----------------------------------
## Installation using Helm
-----------------------------------
$ git clone https://github.com/onkarsawant/pylogger.git
$ cd pylogger/kubernetes

# Validate chart 
$ helm template . --validate

# Packaging Helm Chart 
$ helm package kubernetes/

# Installing new release
- from directory in chart : 
$ helm install pylogger . 

- from a packaged release :
$ helm install pylogger ./pylogger-0.1.0.tgz


# Upgrading release 
$ helm install pylogger ./pylogger-0.1.1.tgz


------------------------------------
## Managing application using GitOps 
------------------------------------
Deploying ArgoCD : https://argo-cd.readthedocs.io/en/stable/getting_started/ 

# Create and Managed application with source as Helm Chart
$ kubectl apply -f pylogger-argocd-app.yaml 
