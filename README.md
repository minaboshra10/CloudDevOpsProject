# Cloud DevOps Project

An end-to-end Cloud DevOps project that automates infrastructure provisioning, server configuration, container image building, security scanning, container registry publishing, and Kubernetes application deployment on AWS.

## Table of Contents

- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [Application Services](#application-services)
- [Technology Stack](#technology-stack)
- [Repository Structure](#repository-structure)
- [Prerequisites](#prerequisites)
- [Local Application Setup](#local-application-setup)
- [AWS Infrastructure Provisioning](#aws-infrastructure-provisioning)
- [Jenkins Server Configuration](#jenkins-server-configuration)
- [CI/CD Pipeline](#cicd-pipeline)
- [Kubernetes Deployment](#kubernetes-deployment)
- [ArgoCD GitOps](#argocd-gitops)
- [Security](#security)
- [Verification](#verification)
- [Important Notes](#important-notes)

## Project Overview

The project demonstrates a cloud-native deployment workflow for a microservices web application.

It uses Terraform to provision AWS infrastructure, Ansible to configure the Jenkins server, Jenkins to automate CI/CD, Trivy to scan Docker images, Amazon ECR to store images, and Amazon EKS to run the application.

Kubernetes manifests are maintained in GitHub, allowing ArgoCD to synchronize the desired application state with the Kubernetes cluster.

## Architecture

The project follows this workflow:

1. Terraform provisions the AWS network, Jenkins EC2 instance, EKS cluster, and ECR repositories.
2. Ansible configures the Jenkins server and installs the required tools.
3. Developers push application changes to GitHub.
4. Jenkins checks out the source code and builds a Docker image.
5. Trivy scans the image for vulnerabilities.
6. Images that pass the security gate are pushed to Amazon ECR.
7. Jenkins updates the corresponding Kubernetes deployment manifest with the new image tag and pushes the change to GitHub.
8. ArgoCD can detect the manifest change and synchronize the application with Amazon EKS.
9. The application is exposed through an AWS Application Load Balancer.

### Architecture Components

| Component | Responsibility |
|---|---|
| AWS VPC | Isolated cloud network |
| Public Subnets | Host public-facing infrastructure |
| Private Subnets | Host EKS worker nodes |
| NAT Gateway | Outbound internet access for private resources |
| Jenkins EC2 | CI/CD automation server |
| Amazon EKS | Managed Kubernetes control plane |
| EKS Node Groups | Kubernetes worker nodes |
| Amazon ECR | Container image registry |
| Terraform | Infrastructure as Code |
| Ansible | Configuration management |
| Docker | Application containerization |
| Jenkins | Continuous Integration and Delivery |
| Trivy | Container vulnerability scanning |
| Kubernetes | Container orchestration |
| AWS Load Balancer Controller | Provisions and manages AWS load balancers |
| ArgoCD | GitOps-based Kubernetes synchronization |

## Application Services

The application consists of three main services and a MySQL database.

### 1. Frontend Service

- Built with Node.js and Express.
- Uses EJS for server-side rendering.
- Handles the web interface, user sessions, and communication with backend services.
- Exposes port `3000`.

### 2. Authentication Service

- Built with Python and Flask.
- Handles user authentication and registration.
- Connects to the MySQL database.
- Exposes port `5000`.

### 3. Roadmap Service

- Built with Java and Maven.
- Provides the DevOps roadmap functionality.
- Exposes port `8080`.

### 4. MySQL Database

- Uses MySQL 8.0.
- Stores application data.
- Uses Kubernetes persistent storage when deployed on EKS.

## Technology Stack

| Category | Technologies |
|---|---|
| Cloud Provider | AWS |
| Infrastructure as Code | Terraform |
| Configuration Management | Ansible |
| CI/CD | Jenkins |
| Containerization | Docker |
| Container Registry | Amazon ECR |
| Container Security | Trivy |
| Container Orchestration | Kubernetes / Amazon EKS |
| GitOps | ArgoCD |
| Load Balancing | AWS Application Load Balancer |
| Frontend | Node.js, Express, EJS |
| Backend | Python, Flask, Java, Maven |
| Database | MySQL |
| Version Control | Git, GitHub |

## Repository Structure

```text
CloudDevOpsProject/
│
├── ansible/
│   ├── ansible.cfg
│   ├── inventory/
│   │   └── aws_ec2.yml
│   ├── playbook.yml
│   └── roles/
│       ├── docker/
│       ├── java/
│       ├── jenkins/
│       └── trivy/
│
├── argocd/
│   └── application.yaml
│
├── auth-service/
│   ├── app.py
│   ├── Dockerfile
│   ├── Jenkinsfile
│   └── requirements.txt
│
├── frontend/
│   ├── Dockerfile
│   ├── Jenkinsfile
│   ├── package.json
│   ├── package-lock.json
│   └── server.js
│
├── kubernetes/
│   ├── namespace.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── storageclass.yaml
│   ├── mysql-statefulset.yaml
│   ├── mysql-headless-service.yaml
│   ├── auth-deployment.yaml
│   ├── auth-service.yaml
│   ├── roadmap-deployment.yaml
│   ├── roadmap-service.yaml
│   ├── frontend-deployment.yaml
│   ├── frontend-service.yaml
│   └── ingress.yaml
│
├── roadmap-service/
│   ├── Dockerfile
│   ├── Jenkinsfile
│   └── pom.xml
│
├── terraform/
│   ├── environments/
│   │   └── dev/
│   │       ├── main.tf
│   │       ├── outputs.tf
│   │       └── provider.tf
│   └── modules/
│       ├── ecr/
│       ├── eks/
│       ├── network/
│       └── server/
│
├── vars/
│   └── microservicePipeline.groovy
│
├── docker-compose.yml
├── .gitignore
└── README.md
```

## Prerequisites

Install the following tools on the machine used to manage the project:

- AWS CLI
- Terraform
- Ansible
- Docker
- kubectl
- Helm
- Git

You also need:

- An AWS account with permissions to provision the required resources.
- An AWS CLI profile configured for the target account.
- An SSH key pair for accessing the Jenkins EC2 instance.
- A GitHub repository containing the project.
- A GitHub credential configured in Jenkins for repository access.

## Local Application Setup

Docker Compose can be used to build and run the application locally.

### 1. Clone the Repository

```bash
git clone https://github.com/minaboshra10/CloudDevOpsProject.git
cd CloudDevOpsProject
```

### 2. Start the Application

```bash
docker compose up --build -d
```

### 3. Check Running Containers

```bash
docker compose ps
```

### 4. Access the Frontend

Open:

```text
http://localhost:3000
```

### 5. Stop the Application

```bash
docker compose down
```

To remove the local MySQL volume as well:

```bash
docker compose down -v
```

**Warning:** Removing the volume deletes the local database data.

## AWS Infrastructure Provisioning

Terraform provisions the AWS infrastructure through reusable modules.

### Infrastructure Resources

- One VPC with CIDR `10.0.0.0/16`.
- Two public subnets across two Availability Zones.
- Two private subnets across two Availability Zones.
- Internet Gateway.
- NAT Gateway.
- Jenkins EC2 instance.
- Amazon EKS cluster.
- Two managed EKS node groups.
- Three Amazon ECR repositories.
- IAM roles and policies for Jenkins and EKS components.

### Terraform Modules

| Module | Purpose |
|---|---|
| network | VPC, subnets, routing, Internet Gateway, NAT Gateway |
| server | Jenkins EC2 instance, security group, IAM role and instance profile |
| eks | EKS cluster, IAM configuration, managed node groups |
| ecr | Container repositories for application services |

### 1. Configure AWS Credentials

Configure an AWS CLI profile:

```bash
aws configure --profile clouddevops
```

Verify the configured identity:

```bash
aws sts get-caller-identity --profile clouddevops
```

### 2. Configure SSH Access

Create an SSH key pair if one does not already exist:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/clouddevops-jenkins
```

Terraform expects the corresponding public key at:

```text
~/.ssh/clouddevops-jenkins.pub
```

### 3. Configure Allowed IP Addresses

Before provisioning, update the `allowed_cidr` and `allowed_cluster_cidr` values in:

```text
terraform/environments/dev/main.tf
```

Use the current public IP address with a `/32` CIDR for administrative access.

### 4. Initialize Terraform

```bash
cd terraform/environments/dev

terraform init
```

### 5. Validate Configuration

```bash
terraform validate
```

### 6. Review the Execution Plan

```bash
terraform plan
```

### 7. Provision Infrastructure

```bash
terraform apply
```

Review the plan and confirm the operation before applying.

### 8. View Infrastructure Outputs

```bash
terraform output
```

Important outputs include:

- VPC ID.
- Public and private subnet IDs.
- Jenkins public IP.
- EKS cluster name.
- ECR repository URLs.
- NAT Gateway ID.

## Jenkins Server Configuration

Jenkins runs on an AWS EC2 instance.

Ansible automates the installation and configuration of the required components.

### Ansible Roles

| Role | Responsibility |
|---|---|
| java | Installs Java |
| docker | Installs and configures Docker |
| trivy | Installs the Trivy vulnerability scanner |
| jenkins | Installs and configures Jenkins |

### Run the Ansible Playbook

From the repository root:

```bash
cd ansible

ansible-inventory -i inventory/aws_ec2.yml --graph

ansible-playbook playbook.yml
```

The playbook waits for the SSH connection and then executes the configuration roles.

### Access Jenkins

Open the Jenkins URL using the public IP of the provisioned EC2 instance:

```text
http://<JENKINS_PUBLIC_IP>:8080
```

Complete the initial Jenkins setup and configure the required credentials and shared library.

### Jenkins Credentials

Configure a GitHub credential with ID:

```text
github-credentials
```

This credential is used by Jenkins to push updated Kubernetes manifests to GitHub.

Do not store personal access tokens, passwords, or private keys in the repository.

### Shared Pipeline Library

The reusable pipeline implementation is located at:

```text
vars/microservicePipeline.groovy
```

Configure the Jenkins Global Pipeline Library with:

- Name: `cloud-devops-shared-library`
- Repository: `https://github.com/minaboshra10/CloudDevOpsProject.git`
- Default branch: `main`

The three service Jenkinsfiles call the shared pipeline with service-specific configuration.

## CI/CD Pipeline

Each application service has its own Jenkins pipeline:

| Service | Jenkinsfile | ECR Repository |
|---|---|---|
| Frontend | frontend/Jenkinsfile | cloud_devops/frontend |
| Auth Service | auth-service/Jenkinsfile | cloud_devops/auth-service |
| Roadmap Service | roadmap-service/Jenkinsfile | cloud_devops/roadmap-service |

### Pipeline Stages

#### 1. Build Image

Jenkins builds a Docker image using the service-specific Dockerfile.

#### 2. Scan Image

Trivy scans the image for security vulnerabilities.

The pipeline uses:

```bash
trivy image \
  --exit-code 1 \
  --severity HIGH,CRITICAL \
  "$IMAGE"
```

If HIGH or CRITICAL vulnerabilities are detected, the pipeline fails and prevents the image from being pushed.

#### 3. Push Image

Jenkins authenticates to Amazon ECR using the EC2 instance IAM role and pushes the image.

Images are tagged using the Jenkins build number.

#### 4. Delete Image Locally

The local Docker image is removed after publishing to reduce disk usage.

#### 5. Update Kubernetes Manifest

Jenkins updates the corresponding Kubernetes Deployment manifest with the new ECR image tag.

#### 6. Push Manifests

Jenkins commits and pushes the updated manifest to the GitHub main branch.

### IAM Permissions

The Jenkins EC2 instance uses an IAM role and instance profile to access Amazon ECR.

The role includes the required authentication, repository inspection, image upload, and image publishing permissions.

No AWS access keys are required inside the Jenkins pipeline.

## Kubernetes Deployment

The application is deployed to Amazon EKS in the `ivolve` namespace.

### Kubernetes Resources

| Resource | Purpose |
|---|---|
| Namespace | Isolates application resources |
| ConfigMap | Stores non-sensitive application configuration |
| Secret | Stores sensitive application configuration |
| StorageClass | Defines persistent storage provisioning |
| StatefulSet | Runs the MySQL database |
| Headless Service | Provides stable MySQL network identity |
| Deployments | Run the frontend and backend services |
| Services | Provide internal service communication |
| Ingress | Exposes the frontend through an AWS ALB |

### Configure kubectl

Update the local kubeconfig:

```bash
aws eks update-kubeconfig \
  --region us-east-1 \
  --name <EKS_CLUSTER_NAME> \
  --profile clouddevops
```

Verify cluster access:

```bash
kubectl get nodes
```

### Inspect Application Resources

```bash
kubectl get all -n ivolve
```

Check persistent storage:

```bash
kubectl get pvc -n ivolve
```

Check the Ingress:

```bash
kubectl get ingress -n ivolve
```

The AWS Load Balancer Controller provisions an internet-facing Application Load Balancer based on the Ingress resource.

### Application Access

Retrieve the Ingress hostname:

```bash
kubectl get ingress -n ivolve
```

Open the hostname in a browser to access the frontend.

## ArgoCD GitOps

The project includes an ArgoCD Application manifest:

```text
argocd/application.yaml
```

The Application is configured to:

- Monitor the GitHub repository.
- Track the `main` branch.
- Use the `kubernetes/` directory as its source.
- Deploy resources into the `ivolve` namespace.
- Enable automated synchronization.
- Enable pruning of removed resources.
- Enable self-healing.

### Apply the ArgoCD Application

After ArgoCD is installed and accessible in the cluster:

```bash
kubectl apply -f argocd/application.yaml
```

Check the Application:

```bash
kubectl get applications -n argocd
```

Check synchronization and health:

```bash
kubectl describe application ivolve-app -n argocd
```

With automated synchronization enabled, changes pushed to the Kubernetes manifests in GitHub can be reconciled by ArgoCD.

## Security

Security is integrated into the infrastructure and CI/CD workflow.

- IAM roles are used for AWS service access.
- Jenkins uses an EC2 instance profile to access ECR.
- EKS resources run in private subnets.
- Administrative access is restricted using allowed IP CIDRs.
- Trivy scans container images before publishing.
- HIGH and CRITICAL vulnerability findings fail the pipeline.
- GitHub credentials are stored in Jenkins Credentials rather than in pipeline source files.
- Sensitive configuration should be managed separately from source code.

## Verification

Useful commands for checking the deployed environment:

### Jenkins

```bash
sudo systemctl status jenkins
```

### Docker

```bash
sudo systemctl status docker
```

### EKS Nodes

```bash
kubectl get nodes
```

### Application Pods

```bash
kubectl get pods -n ivolve
```

### Services and Ingress

```bash
kubectl get svc,ingress -n ivolve
```

### Persistent Storage

```bash
kubectl get pvc -n ivolve
```

### ECR Repositories

```bash
aws ecr describe-repositories \
  --region us-east-1 \
  --profile clouddevops
```

## Important Notes

- Update the allowed IP CIDRs before provisioning or accessing AWS resources from a different public IP.
- Protect SSH private keys, GitHub tokens, AWS credentials, and application secrets.
- The Docker Compose credentials are intended only for local development. Replace them with secure values for any non-local environment.
- Review Kubernetes Secret handling before publishing the repository. Do not commit real passwords or production credentials.
- Terraform state and plan files should not be committed to Git.
- AWS resources such as EKS, NAT Gateway, EC2, and Application Load Balancers may incur charges while running.
- Review AWS resource usage and costs after completing the project.
- Do not destroy infrastructure until application and project requirements have been verified.

---

## Project Status

This repository contains the infrastructure, configuration management, CI/CD, containerization, Kubernetes, and GitOps configuration for the Cloud DevOps project.

The actual deployment and pipeline status should be verified through Jenkins build results and the AWS/Kubernetes environment.
