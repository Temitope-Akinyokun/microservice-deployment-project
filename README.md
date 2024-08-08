# Automated Deployment of Socks Shop Microservices on Kubernetes Using Infrastructure as Code

## Project Overview
This project demonstrates the automated deployment of the Socks Shop microservices-based application on a Kubernetes cluster using Infrastructure as Code (IaaC) principles. The goal is to create a scalable, reliable, and maintainable deployment pipeline that leverages modern DevOps tools and practices.

### Objectives:
- Automated Deployment: Use Terraform (or Ansible) to provision and manage the required cloud infrastructure, including a Kubernetes cluster, VPC, subnets, and security groups.
- Microservices Application: Deploy the Socks Shop application, which consists of multiple microservices, on the Kubernetes cluster.
- Monitoring and Logging: Implement Prometheus for monitoring, Grafana for visualization, and Alertmanager for alerting. Ensure that logs are centralized and accessible for analysis.
- Security: Secure the application by implementing HTTPS using Let’s Encrypt certificates, and enhance the infrastructure’s security with network perimeter rules.
- Maintainability: Ensure that all deployment scripts and configurations are easy to understand, maintain, and reproduce. Sensitive information is securely managed using Ansible Vault.

### Resources

- Socks Shop Microservices Demo: [GitHub Repository](https://github.com/microservices-demo/microservices-demo.github.io)
- Detailed Implementation Guide: [GitHub Repository](https://github.com/microservices-demo/microservices-demo/tree/master)

## Steps

### 1. Set up deployment environment
Launch a T2 Medium Ubuntu instance on AWS to act as the deployment server. On the Ubuntu machine, certain tools are required for smooth deployment such as :
- Terraform
- Kubectl
- AWS CLI
- A running cluster

For easy installation off these tools, the following [script](setup-tools.sh) is used 