# Deploy Todo Application with RDS(MySql) on AWS EC2

![Terraform Plan](https://github.com/Raghav2211/psi-lab/workflows/Terraform%20Plan/badge.svg)

![Todo-RDS-MySql-EC2](todo_phase_1.png)

## About ##
This is an example showing how to deploy a Todo application integrated with RDS(MySql) on to multiple AZs.

1. Here application  and dataBase are deployed in different private subnets which are not directly accessible to outside world.
2. Bastion is on  public subnet which will provide access through ssh to connect to application(EC2) or database (RDS)  for troubleshooting.
3. Nat Gateway provides access to internet to the private subnets.
4. For deploying application on to EC2 we need an AMI (Amazon Machine Image) which will be created using packer.
5. To get high availability of Todo App, we deploy our Todo app to run on at least two Availability Zones (AZs). The load balancer also needs at least 2 public subnets in different AZs.

## Prerequisite ##

- Install AWS CLI

  `https://cloudaffaire.com/how-to-install-aws-cli/`
  
- Install Terraform

  `https://learn.hashicorp.com/tutorials/terraform/install-cli`
  
- Setup AWS credentials

  `https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html`

## Deploy ##


- Create AMI
 
``` bash
  # Go to packer 
  $ cd 3-tier-app/packer/todo
    
  # Create ssh key for ssh in todo cluster
  $ ssh-keygen -t rsa -C "<email-address>" -f todo
    
  # export variables for packer
  $ export APP_VERSION="<todo-app-version>"
  $ export AWS_REGION="<region>"
    
  # Build AMI       
  $ packer build app.json
    
```

- Deploy AWS stack

```bash 
  
  # Go to environment folder in which you want to deploy cluster
  $ cd ../../<env>
  
  # Create VPC
  $ terraform apply -var-file=vpc/terraform.tfvars vpc 
  
  # Create security groups
  $ terraform apply -var-file=security/terraform.tfvars security 
  
  # Create RDS(MySql) cluster
  $ terraform apply -var-file=database/mysql/terraform.tfvars database/mysql
  
  # Create Todo App EC2 cluster
  $ terraform apply -var-file=services/todo/app/terraform.tfvars services/todo/app
    
```

## To check the application ##

- Login to AWS console using your own credentials
- Click on  services and then to EC2
- Under EC2 click on LoadBalancers
- Under LoadBalancers copy DNS Name
- Goto ->> `http://<ALB-DNS>/swagger-ui/`
- Now you should see the swagger page for TODO application


## Troubleshoot ##

- SSH Todo App EC2 instance(s)

```bash
  # Add todo private key to key chain
  $ ssh-add -k <todo_pem_file>
   
  # Access the Bastion Host
  $ ssh -i <bastion_pem_file> -A <bastion_user>@<basion_public_ip>
   
  # Access the private instance
  $ ssh todo@<todo_private_ip>
   
  # Get status
  $ sudo systemctl status todo

```

## Folder layout 
```
.
└── 3-tier-app
    ├── lab
    │   ├── database
    │   │   └── mysql
    │   ├── security
    │   ├── services
    │   │   └── todo
    │   │       └── app
    │   │           └── templates
    │   └── vpc
    ├── modules
    │   ├── app-server
    │   ├── database
    │   │   └── mysql
    │   │       └── example
    │   ├── ec2
    │   ├── eks
    │   └── network
    │       ├── example
    │       │   └── complete-network
    │       ├── test
    │       └── userdata
    ├── packer
    │   └── todo
    │       ├── app.json
    │       ├── scripts
    │       ├── services
    │       └── todo
    └── test
```


## AWS Resources used for Todo Application

- AWS EBS (Elastic Block Storage)
- AWS EC2 (Elastic Compute Cloud)
- AWS RDS (Relational Database Service)
- AWS VPC (Virtual Private Cloud)
- AWS IGW (Internet GateWay)
- AWS ALB (Application Load Balancer)
- AWS ASG (Auto Scaling Group)
- AWS NAT (Network Address Translation)
- AWS SG  (Security Group)
- AWS AMI (Amazon Machine Image)
