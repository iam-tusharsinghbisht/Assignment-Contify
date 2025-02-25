# Deployment of Python-Django Web Application on AWS

## Overview
This document provides a step-by-step guide to automate the deployment of a Python-Django web application on AWS using Terraform, Ansible, and Jenkins. 

## 1. Infrastructure as Code (IaC) using Terraform

### 1.1 Install Terraform
- Download and install Terraform from [https://www.terraform.io/downloads](https://www.terraform.io/downloads).
- Verify installation:
  ```bash
  terraform --version
  ```

### 1.2 Define Terraform Configuration
- You need to be in same directory as Infrastrucute/`main.tf`.

- VPC, subnets, NAT Gateway, EC2 instances, ALB, RDS for PostgreSQL, and S3 bucket are inside modules folder for better management.

- Update variable values in `terraform.tfvars` file.

- Apply Terraform configuration:
  ```bash
  terraform init
  terraform validate
  terraform plan
  terraform apply -var-file=terraform.tfvars
  ```

## 2. Configuration Management using Ansible

### 2.1 Install Ansible
- Install Ansible on the CI/CD EC2 instance:
  ```bash
  sudo apt update
  sudo apt install -y ansible
  ```

### 2.2 Configure Ansible Playbooks
- Create playbooks to:
  - Install & configure Nginx as a reverse proxy.
  - Install & configure Django + Gunicorn.
  - Setup PostgreSQL.

- Run the Ansible playbook:
  ```bash
  ansible-playbook -i inventory setup.yml
  ```

## 3. CI/CD Pipeline Setup

### 3.1 Jenkins Setup
- Install Jenkins on the CI/CD EC2 instance:
  ```bash
  sudo apt update
  sudo apt install -y openjdk-17-jdk
  ```

  ```bash
  curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]
    https://pkg.jenkins.io/debian binary/ | sudo tee
    /etc/apt/sources.list.d/jenkins.list > /dev/null
  sudo apt update
  sudo apt install -y jenkins
  sudo systemctl start jenkins
  ```

- Check if Jenkins is running:
  ```bash
  sudo systemctl status jenkins
  ```

### 3.2 Configure CI/CD Pipeline
- Create a freestyle pipeline
- Set the pipleine to get script(CICD/Jenkinsfile) from Github SCM
- Save the pipeline
- Create a webhook on Github so any changes in github repo will trigger the pipeline.


## 4. Disaster Recovery:
- Setup cronjob to automatically backup database daily inside PostgreSQL database Instance using `backup.sh` script.

- Ensure the application can be restored within 1 hour in case of failure.

### Disaster Recovery Plan

#### Infrastructure Reprovisioning:
Since the infrastructure is consistently provisioned using Terraform and configured via Ansible, the entire environment can be recreated swiftly within 1 hour after a disaster.

#### Database Restoration:
A restore script will be used to restore the database from backups, ensuring minimal data loss and a quick recovery using `restore.sh`.



## Conclusion
Following these steps will ensure a fully automated, secure, and scalable deployment of the Django application on AWS.



