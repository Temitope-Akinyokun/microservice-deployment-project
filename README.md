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

For easy installation off these tools, the following [script](setup-tools.sh) is used by:
- Setting appropriate permissions to make the script  executable 
```bash
    chmod +x setup-tools.sh
```

- Running the script:
```bash
    ./setup-tools.sh
```
### 2. Accessing Jenkins 
2.1 Verify Jenkins installation
- Check Jenkins status
```bash
    sudo systemctl status jenkins
```

If it is not running, start using
```bash
    sudo systemctl start jenkins
```
2.2 Configure security groups
-Ensure that the AWS security group associated with your instance permits inbound traffic on port 8080 (or the port Jenkins is configured to use). By default, Jenkins operates on port 8080.

To update the security group settings:

- Log in to the AWS Management Console.
- Navigate to the EC2 service.
- Select your instance.
- Update the inbound rules of the associated security group to allow traffic on port 8080 from your IP address or from any source.


2.3 Access jenkins from browser
- The Jenkins server can be accessed by copying the public IP address of the provisioned virtual machine and opening it in a browser on port 8080. The URL will appear as follows: 
```bash
http://<public_ip_address>:8080
```

or

```bash
http://<public_dns_name>:8080
```

2.4 Initial Jenkins setup
- Retrieve the initial admin password
```bash
    sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
- Enter the password in the Jenkins web interface to complete the setup.

2.5 Complete Jenkins setup
- Follow the Jenkins web interface instructions to install recommended plugins and create an admin user.

### 3.Running a Jenkins Pipeline Build from a GitHub Repository Using a Cluster-Jenkinsfile
