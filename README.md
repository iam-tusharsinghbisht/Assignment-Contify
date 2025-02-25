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

Please follow the below steps to Create the infrastructure using terraform:
    Step 1: cd Infrastructure
    Step 2: terraform init
    Step 3: terraform validate
    Step 4: Terraformm plan
    Step 5: terraform apply

Create Jenkins Pipeline using the Jenkins file provided in the CICD folder.
    - Install jenkins in CICD instance
    - Create a freestyle pipeline
    - Set the pipleine to get script(CICD/Jenkinsfile) from Github SCM
    - Save the pipeline
    - Create a webhook on Github so any changes in github repo will trigger the pipeline.

Setup cronjob to automatically backup database daily



