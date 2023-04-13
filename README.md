- [Cloud projects](#cloud-projects)
  - [IaC using Terraform and CI/CD](#iac-using-terraform-and-cicd)
  - [Create an EC2 instance in AWS](#create-an-ec2-instance-in-aws)
    - [Install Terraform in the developer laptop](#install-terraform-in-the-developer-laptop)
    - [Execute Terraform code](#execute-terraform-code)

# Cloud projects
## IaC using Terraform and CI/CD
Aswathi Shiju - [LinkedIn profile](https://www.linkedin.com/in/aswathi-shiju/)

This repository contains Terraform based infrastructure of code experiments I tried out during my cloud learning journey. As they say , learning is for a life time :) 

It is a work-in-progress, I am adding new projects as I progress though different use cases.

If you would like to try out this code , please feel free to clone this repo.In case you have any questions please send a message in LinkedIn or raise a github issue. 

## Create an EC2 instance in AWS 

The main.tf file in cloud_projects/aws/tf_ec2/ contains the Terraform code to launch an EC2 virtual machine in Amazon AWS cloud.

I started Terraform learning with this script. This script launches a virtual machine in default VPC. Also I am not attaching any private keys with the virtual machine in this script , so for VM access we need to create an SSM role and attach with the VM manually. Detailed steps are available in this [documentation](https://docs.aws.amazon.com/systems-manager/latest/userguide/setup-instance-permissions.html).

The system performs the following steps:
### Install Terraform in the developer laptop
To run Terraform code we need to install Terraform application on the developer laptop first. Detailed instructions matching your operating system is available from this [link](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).
 
 ### Execute Terraform code

Once Terraform is installed in the laptop , we can validate the script with below command and then if there are no errors proceed to code formatting with terraform fmt command.

    cd to the directory where main.tf is saved
    terraform validate .
    terraform fmt .

Now proceed to terraform plan

    terraform plan

Finally apply the code to create AWS resources

    terraform apply

>Note
 Export the AWS secret key and access key in terminal before running the terraform commands. ( So that Terraform can connect to your AWS account )
 e:g
 export AWS_ACCESS_KEY_ID=AXXXXXXXXXXXXXXXXX
 export AWS_SECRET_ACCESS_KEY=VXxxxxYyyyyyyPpppppQqqqqq
