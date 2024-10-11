# Project Task: Building Infrastructure with Terraform and Configuring Docker with Ansible
## Objective:
The goal of this project is to build and manage infrastructure across two availability zones (AZs) using __Terraform__ and configure Docker on private machines using **Ansible**. The project utilizes **GitOps** practices for managing configurations, with **Jenkins** as the **CI/CD** tool to automate the entire workflow.
## Tools Required:
- __Terraform__: For building and provisioning cloud infrastructure.
- **Ansible**: For configuration management and automating server provisioning.
- **Docker**: To install on private instances and run Nginx containers.
- **GitOps**: To manage configurations and use CI/CD for automations.
- **CI/CD Tools**: Jenkins for continuous integration and delivery.
## Task Breakdown:
1. ### Terraform Infrastructure Setup:
- **Create VPC** and define the networking structure (subnets, route tables, security groups, etc..).
- **Subnet Setup**:
  -Each AZ will have two subnets:
    - One **Public Subnet** for public-facing services like the Bastion Host.
    - One **Private Subnet** for internal services like Docker.
      
- **Outputs**:
  - Capture the private IPs of instances for Ansible inventory.
2. ### Bastion Host Configuration:
- **Bastion Host Setup**:
  - Deploy a Bastion Host in the public subnet of each AZ.
  - The Bastion Host will allow secure access to private instances.
- **File Transfer**:
  - Copy Ansible roles and playbooks to the Bastion Host after infrastructure creation.
3. ### Ansible Configuration:
  - **Docker Installation**:
    - Use Ansible to install Docker on the private instances.
  - **Nginx Container Setup**:
    - Run an Nginx container on each private instance.
  - **Ansible Role**:
    - Create a custom Ansible role for Docker installation and service configuration.
4. ###  GitOps Implementation:
  - **GitOps Workflow**:
    - Manage all configurations (Terraform and Ansible) via a Git repository.
  - **CI/CD Pipeline**:
    - Implement an automated deployment pipeline using Jenkins to trigger:
      - Infrastructure provisioning with Terraform.
      - Configuration management with Ansible.
# Hints:
- Ansible playbooks will be executed from the Bastion Host to configure private instances.
- Use Terraform output to generate an Ansible inventory file for target hosts.
- All infrastructure, playbooks, and configurations should be version-controlled in Git.
### CI/CD Pipeline Flow:
1. ### Terraform Plan and Apply:
  - Create the necessary infrastructure.
2. ### Ansible Playbook Execution:
  - Configure private instances with Docker and Nginx via the Bastion Host.
3. ### Continuous Delivery:
  - Jenkins automatically manages infrastructure updates and Ansible playbook executions as code changes are pushed.

#
    
By following the above steps, you can automate the infrastructure provisioning and application configuration across multiple environments, using best practices in **DevOps** and **GitOps**.



