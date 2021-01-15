# Deploying SpringBoot Application with RDS(MySql) on AWS EC2 using terraform

![SpringBoot-RDS-MySql-EC2](todo_phase_1.png)

1. This is an example showing how to deploy a SpringBoot application integrated with RDS(MySql) on to multiple AZs.
2. Here Application  and DataBase are deployed in different private subnet which are not directly accessible to outside world.
3. Bastion and Nat Gateway are on public subnet which will provide access through ssh to connect to application(EC2) or database (RDS) box for troubleshooting.
4. For deploying application on to EC2 we need an AMI (Amazon Machine Image) which will be created using packer.

## Steps to deploy application ##

- Install AWS CLI

  `https://cloudaffaire.com/how-to-install-aws-cli/`
  
- Install Terraform

  `https://learn.hashicorp.com/tutorials/terraform/install-cli`
  
- Setup AWS credentials

  `https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html`
  
- Move to lab folder  in current project like below

```bash 
  
  /todo-app/aws/3-tier-app/lab
    
```
  
- Run below command to install dependencies for VPC terraform script

```bash 
     
  terraform init -var-file=vpc/terraform.tfvars vpc 
  
```
- Run below command to verify the plan for VPC terraform script

``` bash 
     
  terraform plan -var-file=vpc/terraform.tfvars vpc 
  
```
- Run below command to create VPC on AWS

``` bash 
     
  terraform apply -var-file=vpc/terraform.tfvars vpc 
  
```

- Run below command to install dependencies for Security group terraform script

``` bash 
     
  terraform destroy -var-file=security/terraform.tfvars security 
  
```
- Run below command to verify plan for security terraform script

``` bash 
     
  terraform plan -var-file=security/terraform.tfvars security 
  
```
- Run below command to create security group 

``` bash 
     
  terraform apply -var-file=security/terraform.tfvars security 
  
```
- Run below command to install dependencies for database terraform script

``` bash 
     
  terraform init -var-file=database/mysql/terraform.tfvars database/mysql
  
```
- Run below command to verify plan for database terraform script

``` bash 
     
  terraform plan -var-file=database/mysql/terraform.tfvars database/mysql
  
```
- Run below command to create database

``` bash 
     
  terraform apply -var-file=database/mysql/terraform.tfvars database/mysql
  
```
- Move to packer folder in the current project
 
``` bash
    
    /todo-app/aws/3-tier-app/packer
    
```
- Run below commands to create ssh key and set environment variables

``` bash     
  eval `ssh-agent -s`
  ssh-keygen -t rsa -C "your_email@example.com" -f todo
  export APP_VERSION="1.0.0"
  export AWS_REGION="us-west-2"       
```
  
- Run below command to validate AMI image creation using packer

``` bash
 packer validate todo.json
```
- Run below command to create AMI image of the SpringBoot Application using packer and upload to AWS EBS

``` bash
  
 packer build todo.json
     
```
- Run below command to install dependencies for deploying above created AMI on to EC2

```bash
  terraform init -var-file=services/todo/app/terraform.tfvars services/todo/app
  
```
- Run below command to verify plan for deploying above created AMI on to EC2

```bash

  terraform plan -var-file=services/todo/app/terraform.tfvars services/todo/app
  
```
- Run below command to  deploy above created AMI on to EC2

```bash

  terraform apply -var-file=services/todo/app/terraform.tfvars services/todo/app
  
```

## To check the application ##

- Login to AWS console using your own credentials
- Click on  services and then to EC2
- Under EC2 click on LoadBalancers
- Under LoadBalancers goto DNS Name
- Copy that and past to web browser with appending '/swagger-ui/
- Now you should see the swagger page for TODO application

## To check TODO application status for troubleshoot ##

- Run below command to install dependencies for bastion terraform script

```bash

   terraform init -var-file=bastion/terraform.tfvars bastion

```

- Run below command to verify  bastion terraform script

```bash

   terraform plan -var-file=bastion/terraform.tfvars bastion

```

- Run below command to create  bastion or jumpbox on AWS

```bash

   terraform apply -var-file=bastion/terraform.tfvars bastion

```
- Now log on to AWS Console and click on services
- Then click on EC2.
- Then click on EC2 instance with having bastion in name.
- Then copy the public ip of bastion EC2
- Run below command 

```bash
  ssh -i <private key file(todo)> -A todo@<public ip copied in above step>
  ssh -i <private key file(todo)> -A todo@<public ip of application ec2 instance>
  sudo systemctl status todo
  
```



## What you'll need

- Terraform
- Packer
- AWS Config CLI
- AWS EBS
- AWS EC2
- AWS RDS
- AWS VPC
- AWS IGW
- AWS ALB
- AWS ASG
- AWS NAT