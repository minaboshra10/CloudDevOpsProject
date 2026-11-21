# Cloud DevOps Project

An end-to-end Cloud DevOps project that automates infrastructure provisioning, server configuration, container image building, security scanning, container registry publishing, and Kubernetes application deployment on AWS.

## Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Application Services](#application-services)
4. [Technology Stack](#technology-stack)
5. [Repository Structure](#repository-structure)
6. [Prerequisites](#prerequisites)
7. [Local Application Setup](#local-application-setup)
8. [AWS Infrastructure Provisioning](#aws-infrastructure-provisioning)
9. [Jenkins Server Configuration](#jenkins-server-configuration)
10. [CI/CD Pipeline](#cicd-pipeline)
11. [Kubernetes Deployment](#kubernetes-deployment)
12. [ArgoCD GitOps](#argocd-gitops)
13. [Security](#security)
14. [Verification](#verification)
15. [Important Notes](#important-notes)
16. [Project Status](#project-status)

---

## 1. Project Overview

The project demonstrates an end-to-end cloud-native deployment workflow for a microservices web application.

It uses:

- **Terraform** to provision AWS infrastructure.
- **Ansible** to configure the Jenkins server.
- **Docker** to containerize application services.
- **Jenkins** to automate CI/CD pipelines.
- **Trivy** to scan container images for vulnerabilities.
- **Amazon ECR** to store container images.
- **Amazon EKS** to run the application on Kubernetes.
- **ArgoCD** to implement GitOps-based deployment synchronization.

Kubernetes manifests are maintained in GitHub. Jenkins updates the image tags after successful builds and security scans, while ArgoCD detects repository changes and synchronizes the desired state with the EKS cluster.

## 2. Architecture

### Architecture Workflow

1. Terraform provisions the AWS network, Jenkins EC2 instance, EKS cluster, and ECR repositories.
2. Ansible configures the Jenkins server and installs the required tools.
3. Developers push application changes to GitHub.
4. Jenkins checks out the source code and builds a Docker image.
5. Trivy scans the image for HIGH and CRITICAL vulnerabilities.
6. Images that pass the security gate are pushed to Amazon ECR.
7. Jenkins updates the corresponding Kubernetes Deployment manifest with the new image tag.
8. Jenkins commits and pushes the updated manifest to GitHub.
9. ArgoCD detects the manifest change and synchronizes the application with Amazon EKS.
10. The application is exposed through an AWS Application Load Balancer.

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

## 3. Application Services

The application consists of three microservices and a MySQL database.

### 3.1 Frontend Service

- Built with Node.js and Express.
- Uses EJS for server-side rendering.
- Handles the web interface and user sessions.
- Communicates with the backend services.
- Exposes port `3000`.

### 3.2 Authentication Service

- Built with Python and Flask.
- Handles user authentication and registration.
- Connects to the MySQL database.
- Exposes port `5000`.

### 3.3 Roadmap Service

- Built with Java and Maven.
- Provides the DevOps roadmap functionality.
- Exposes port `8080`.

### 3.4 MySQL Database

- Uses MySQL 8.0.
- Stores application data.
- Uses persistent Kubernetes storage when deployed on EKS.

## 4. Technology Stack

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

## 5. Repository Structure

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

## 6. Prerequisites

Install the following tools on the machine used to manage the project:

- AWS CLI
- Terraform
- Ansible
- Docker
- kubectl
- Helm
- Git
- SSH client

You also need:

- An AWS account with permissions to provision the required resources.
- An AWS CLI profile configured for the target account.
- An SSH key pair for accessing the Jenkins EC2 instance.
- A GitHub repository containing the project.
- A GitHub credential configured in Jenkins for repository access.

## 7. Local Application Setup

Docker Compose can be used to build and run the application locally.

### 7.1 Clone the Repository

```bash
git clone https://github.com/minaboshra10/CloudDevOpsProject.git
cd CloudDevOpsProject
```

### 7.2 Start the Application

```bash
docker compose up --build -d
```

### 7.3 Check Running Containers

```bash
docker compose ps
```

### 7.4 Access the Frontend

Open the following URL:

```text
http://localhost:3000
```

### 7.5 Stop the Application

```bash
docker compose down
```

To remove the local MySQL volume as well:

```bash
docker compose down -v
```

**Warning:** Removing the volume deletes the local database data.

## 8. AWS Infrastructure Provisioning

Terraform provisions the AWS infrastructure through reusable modules.

### 8.1 Infrastructure Resources

The infrastructure includes:

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

### 8.2 Terraform Modules

| Module | Purpose |
|---|---|
| network | VPC, subnets, routing, Internet Gateway, NAT Gateway |
| server | Jenkins EC2 instance, security group, IAM role and instance profile |
| eks | EKS cluster, IAM configuration, managed node groups |
| ecr | Container repositories for application services |

### 8.3 Configure AWS Credentials

Configure an AWS CLI profile:

```bash
aws configure --profile clouddevops
```

Verify the configured identity:

```bash
aws sts get-caller-identity --profile clouddevops
```

### 8.4 Configure SSH Access

Create an SSH key pair if one does not already exist:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/clouddevops-jenkins
```

Terraform expects the corresponding public key at:

```text
~/.ssh/clouddevops-jenkins.pub
```

### 8.5 Configure Allowed IP Addresses

Before provisioning, update the `allowed_cidr` and `allowed_cluster_cidr` values in:

```text
terraform/environments/dev/main.tf
```

Use the current public IP address with a `/32` CIDR for administrative access.

### 8.6 Initialize Terraform

```bash
cd terraform/environments/dev

terraform init
```

### 8.7 Validate Configuration

```bash
terraform validate
```

### 8.8 Review the Execution Plan

```bash
terraform plan
```

### 8.9 Provision Infrastructure

```bash
terraform apply
```

Review the execution plan and confirm the operation before applying.

### 8.10 View Infrastructure Outputs

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

## 9. Jenkins Server Configuration

Jenkins runs on an AWS EC2 instance.

Ansible automates the installation and configuration of the required components.

### 9.1 Ansible Roles

| Role | Responsibility |
|---|---|
| java | Installs Java |
| docker | Installs and configures Docker |
| trivy | Installs the Trivy vulnerability scanner |
| jenkins | Installs and configures Jenkins |

### 9.2 Run the Ansible Playbook

From the repository root:

```bash
cd ansible

ansible-inventory -i inventory/aws_ec2.yml --graph

ansible-playbook playbook.yml
```

The playbook waits for the SSH connection and then executes the configuration roles.

### 9.3 Access Jenkins

Open the Jenkins URL using the public IP of the provisioned EC2 instance:

```text
http://<JENKINS_PUBLIC_IP>:8080
```

Complete the initial Jenkins setup and configure the required credentials and shared library.

### 9.4 Jenkins Credentials

Configure a GitHub credential with ID:

```text
github-credentials
```

This credential is used by Jenkins to push updated Kubernetes manifests to GitHub.

Do not store personal access tokens, passwords, or private keys in the repository.

### 9.5 Shared Pipeline Library

The reusable pipeline implementation is located at:

```text
vars/microservicePipeline.groovy
```

Configure the Jenkins Global Pipeline Library with:

| Setting | Value |
|---|---|
| Name | cloud-devops-shared-library |
| Repository | https://github.com/minaboshra10/CloudDevOpsProject.git |
| Default branch | main |

The three service Jenkinsfiles call the shared pipeline with service-specific configuration.

## 10. CI/CD Pipeline

Each application service has its own Jenkins pipeline.

### 10.1 Pipeline Configuration

| Service | Jenkinsfile | ECR Repository |
|---|---|---|
| Frontend | frontend/Jenkinsfile | cloud_devops/frontend |
| Auth Service | auth-service/Jenkinsfile | cloud_devops/auth-service |
| Roadmap Service | roadmap-service/Jenkinsfile | cloud_devops/roadmap-service |

### 10.2 Pipeline Stages

#### 1. Build Image

Jenkins checks out the source code and builds a Docker image using the service-specific Dockerfile.

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

Jenkins commits and pushes the updated manifest to the GitHub `main` branch.

### 10.3 IAM Permissions

The Jenkins EC2 instance uses an IAM role and instance profile to access Amazon ECR.

The role includes the required authentication, repository inspection, image upload, and image publishing permissions.

No AWS access keys are required inside the Jenkins pipeline.

## 11. Kubernetes Deployment

The application is deployed to Amazon EKS in the `ivolve` namespace.

### 11.1 Kubernetes Resources

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

### 11.2 Configure kubectl

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

### 11.3 Inspect Application Resources

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

### 11.4 Application Access

Retrieve the Ingress hostname:

```bash
kubectl get ingress -n ivolve
```

Open the generated hostname in a browser to access the frontend.

## 12. ArgoCD GitOps

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

### 12.1 Apply the ArgoCD Application

After ArgoCD is installed and accessible in the cluster:

```bash
kubectl apply -f argocd/application.yaml
```

### 12.2 Check the Application

```bash
kubectl get applications -n argocd
```

Check synchronization and health:

```bash
kubectl describe application ivolve-app -n argocd
```

With automated synchronization enabled, changes pushed to the Kubernetes manifests in GitHub can be reconciled by ArgoCD.

## 13. Security

Security is integrated into the infrastructure and CI/CD workflow.

- IAM roles are used for AWS service access.
- Jenkins uses an EC2 instance profile to access ECR.
- EKS worker nodes run in private subnets.
- Administrative access is restricted using allowed IP CIDRs.
- Trivy scans container images before publishing.
- HIGH and CRITICAL vulnerability findings fail the pipeline.
- GitHub credentials are stored in Jenkins Credentials rather than in pipeline source files.
- Sensitive values must not be committed to Git.
- Kubernetes Secrets or an appropriate secrets-management solution should be used for sensitive configuration, with access restricted to authorized users and workloads.

## 14. Verification

Use the following commands to verify the deployed environment.

### 14.1 Jenkins

```bash
sudo systemctl status jenkins
```

### 14.2 Docker

```bash
sudo systemctl status docker
```

### 14.3 EKS Nodes

```bash
kubectl get nodes
```

### 14.4 Application Pods

```bash
kubectl get pods -n ivolve
```

### 14.5 Services and Ingress

```bash
kubectl get svc,ingress -n ivolve
```

### 14.6 Persistent Storage

```bash
kubectl get pvc -n ivolve
```

### 14.7 ArgoCD Application

```bash
kubectl get applications -n argocd
```

Confirm that the application reports `Synced` and `Healthy`.

### 14.8 ECR Repositories

```bash
aws ecr describe-repositories \
  --region us-east-1 \
  --profile clouddevops
```

### 14.9 Jenkins Pipeline Results

Verify that all three service pipelines complete successfully:

- Frontend
- Authentication Service
- Roadmap Service

Review the Jenkins Console Output to confirm successful image building, Trivy scanning, ECR publishing, and manifest updates.

## 15. Important Notes

- Update the allowed IP CIDRs before provisioning or accessing AWS resources from a different public IP.
- Protect SSH private keys, GitHub tokens, AWS credentials, and application secrets.
- Docker Compose credentials are intended only for local development. Replace them with secure values for any non-local environment.
- Review Kubernetes Secret handling before publishing the repository. Do not commit real passwords or production credentials.
- Terraform state and plan files should not be committed to Git.
- AWS resources such as EKS, NAT Gateway, EC2, and Application Load Balancers may incur charges while running.
- Review AWS resource usage and costs after completing the project.
- Do not destroy infrastructure until application and project requirements have been verified.

## 16. Project Status

The Cloud DevOps project implementation includes:

- AWS infrastructure provisioned using Terraform.
- Jenkins server configured using Ansible.
- Three application services containerized with Docker.
- Jenkins CI/CD pipelines successfully executed for Frontend, Authentication Service, and Roadmap Service.
- Trivy vulnerability scanning integrated into all three pipelines, with HIGH and CRITICAL findings configured to fail the pipeline.
- Docker images published to Amazon ECR.
- Application deployed on Amazon EKS in the `ivolve` namespace.
- ArgoCD configured to synchronize Kubernetes manifests from the GitHub repository.

The three Jenkins pipelines have completed successfully. The final Kubernetes and ArgoCD deployment state should be confirmed using the verification commands in this README before submission.

---

**Repository:** https://github.com/minaboshra10/CloudDevOpsProject

**Project:** Cloud DevOps — AWS, Terraform, Ansible, Jenkins, Docker, Trivy, ECR, Kubernetes, EKS, and ArgoCD.
