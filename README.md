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
- Inside `main.tf` to define AWS resources:

- Create VPC, subnets, NAT Gateway, EC2 instances, ALB, RDS for PostgreSQL, and S3 bucket for logs.

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
  - Implement log rotation.

- Run the Ansible playbook:
  ```bash
  ansible-playbook -i inventory setup.yml
  ```

Create Jenkins Pipeline using the Jenkins file provided in the CICD folder.
    - Install jenkins in CICD instance
    - Create a freestyle pipeline
    - Set the pipleine to get script(CICD/Jenkinsfile) from Github SCM
    - Save the pipeline
    - Create a webhook on Github so any changes in github repo will trigger the pipeline.

Setup cronjob to automatically backup database daily

## Conclusion
Following these steps will ensure a fully automated, secure, and scalable deployment of the Django application on AWS, adhering to best practices.



