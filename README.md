# Automated Deployment of Sock Shop Microservices on Kubernetes Using Infrastructure as Code

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
3.1 Install pipeline plugin which is necessary for setup
- On the Jenkins dashboard, navigate to the "manage Jenkins" setup.
- Navigate to the "Manage Plugins".
- Navigate to the "Avaialable" top.
- Search for "Pipeline" plugin. Click to install.

3.2 Jenkins credentials configuration
- The GitHub repository is public so there's no need to set up credentials. 


3.2 Add credentials in Jenkins to access your GitHub repository. Choose either “Username with password” or SSH credentials based on your repository’s authentication method.

3.3 Create a Jenkins pipeline job
- Navigate to Jenkins dashboard → "New Item" → Enter job name → Select "Pipeline" → Click "OK".
- In the job configuration, go to the “Pipeline” section.
- Choose to define the pipeline script directly in Jenkins or from a source code management (SCM) system like Git(For this case, it's the latter option).
- Select “Pipeline script from SCM”, choose “Git” as the SCM, and enter the repository URL (e.g., https://github.com/username/repository.git).
- Specify the branch and any additional options like script path or lightweight checkout.

3.4 Write the Jenkinsfile

This Jenkins pipeline [file](cluster-Jenkinsfile) automates the management of an AWS EKS cluster using Terraform, enabling users to easily create or destroy the cluster based on input parameters. By leveraging Jenkins for orchestration, the script streamlines the provisioning and teardown processes, providing a straightforward approach to managing the EKS cluster lifecycle.

- Here's a brief expanation of what each code block does:

    - Pipeline: Begins the definition of the Jenkins pipeline, outlining the entire process for the build or deployment.

    - Agent: Specifies where the pipeline will run, indicating that it can execute on any available Jenkins agent.

    - Environment: Sets environment variables that the pipeline will use, including credentials for accessing AWS and the default AWS region.

    - Parameters: Defines user inputs that affect the pipeline’s behavior. In this case, it allows users to choose between creating or destroying an EKS cluster.

    - Stages: Groups related steps into distinct phases of the pipeline. Each stage represents a specific part of the build or deployment process.

    - Steps: Contains the actual commands or scripts to be executed within each stage. For instance, this might involve initializing and applying Terraform configurations to manage an EKS cluster based on user input.

3.5 Save and run the job manually by clicking on "Build Now".

3.6 Check build progress, console output, and logs on the Jenkins dashboard.

### 4. Setup Terraform configuration to provision and manage the infrastructure on AWS. 
The configuration is organized into logical segments to streamline the deployment process:

- Versions and Global Configuration
    - 01-versions.tf: Defines Terraform and provider versions.
    - 02-01-generic-variables.tf: Contains generic variables for multiple modules.
    - 02-02-local-values.tf: Defines local values for reuse within configurations.

- Networking and VPC Setup
    - 03-01-vpc-variables.tf: Variables for VPC configuration.
    - 03-02-vpc-module.tf: VPC setup module.
    - 03-03-vpc-outputs.tf: VPC outputs.

- Bastion Host Configuration
    - 04-01-bastion-variables.tf: Variables for Bastion host.
    - 04-02-bastion-sg.tf: Bastion host security group.
    - 04-03-ami-datasource.tf: AMI ID data source.
    - 04-04-bastion-outputs.tf: Bastion host outputs.
    - 04-05-bastion-ec2-instance.tf: EC2 instance configuration.
    - 04-06-bastion-elastic-ip.tf: Elastic IP allocation.
    - 04-07-ec2-bastion-provisioners.tf: Bastion host provisioners.

- EKS Cluster Setup
    - 05-01-eks-variables.tf: EKS variables.
    - 05-02-eks-outputs.tf: EKS outputs.
    - 05-03-iamrole-eks.tf: IAM roles for EKS.
    - 05-04-iamrole-nodegroup.tf: IAM roles for node groups.
    - 05-06-eks-cluster.tf: EKS cluster configuration.
    - 05-07-node-group-public.tf: Public node groups.
    - 05-08-eks-node-group-private.tf: Private node groups.

- Variable Files
    - ec2-bastion.auto.tfvars: Bastion host variable values.
    - eks.auto.tfvars: EKS cluster variable values.
    - terraform.tfvars: Common variable values.
    - vpc.auto.tfvars: VPC variable values.

### 5. Deploying Sock Shop microservices
To facilitate the deployment of a microservices architecture using Terraform, the following configuration files are utilized:

- [provider.tf](kubernetes/micro-services/provider.tf): Sets up the cloud provider and namespace configurations.
- [carts.tf](kubernetes/micro-services/carts.tf): Manages the deployment of the Carts service and its MongoDB database.
- [catalogue.tf](kubernetes/micro-services/catalogue.tf): Configures the deployment of the Catalogue service along with its MySQL database.
- [frontend.tf](kubernetes/micro-services/frontend.tf): Deploys the Frontend service without a database.
- [orders.tf](kubernetes/micro-services/orders.tf): Handles the deployment of the Orders service and its MongoDB database.
- [payments.tf](kubernetes/micro-services/payments.tf): Manages the deployment of the Payments service.
- [queue-master.tf](kubernetes/micro-services/queue-master.tf): Sets up the Queue Master service with specified resource limits.
- [rabbitmq.tf](kubernetes/micro-services/rabbitmq.tf): Deploys RabbitMQ with an exporter for monitoring.
- [session-db.tf](kubernetes/micro-services/session-db.tf): Configures Redis for managing session data.
- [shipping.tf](kubernetes/micro-services/shipping.tf): Manages the deployment of the Shipping service.
- [user.tf](kubernetes/micro-services/user.tf): Deploys the User service with MongoDB and includes volume mounts for persistent storage.