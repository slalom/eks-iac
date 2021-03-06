# This terraform templates (IaC) creates:
1. a VPC
2. 3 Subnets (web (Internet Gateway), app (EKS) and db (Aurora RDS))
3. EKS Cluster
4. EKS Worker Nodes (How-many is configurable via variables)
5. AWS Systems Manager - Session manager so you can SSH into the EC2 worker nodes
6. An Aurora RDS DB (engine and instance configurable via variables)

# Tooling pre-reqs
## You must have the following installed
1. aws CLI (python3.7 and pip3)
2. aws-aim-authenticator (https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)
3. kubectl (https://kubernetes.io/docs/tasks/tools/install-kubectl/)
4. eksctl (https://eksctl.io/introduction/installation/) 
5. terraform (https://learn.hashicorp.com/terraform/getting-started/install.html)

# To run the terraform script
#### Ensure you have a terraform.tfvars, then run
#### NOTE:  (sample variables found at the bottom of this doc)

1. terraform plan
2. terraform apply

## Connecting to the cluster
#### After terraform completes, you can update your local kubectl config by running

aws eks --region region update-kubeconfig --name cluster_name

### To Swtich Context
kubectl config use-context *context-name*  from the command above.

Then run `kubectl get svc` and you will see your cluster.

## Wiring up Worker Node Access
Currently Terraform doesn't have a built-in way of joining the worker nodes. There is a proposed way to do it via the `kubernetes provider` which is implemented but it usually times out.  When it times out, you can run `terraform apply` again and it works the second time.

### Terraform's official Doc on Nodes Joining
Run 
1. terraform output config_map_aws_auth >nodes_aws_auth.yml
2. kubectl apply -f nodes_aws_auth.yml
3. kubectl get nodes --watch

You'll see the nodes come online

### Assuming Role For admin (root) team members that did not create the cluster
After the cluster creator has done the steps above, other root/admin team members can configure their local desktop 
by following docs/AssumingEKSRootRole.me instructions

# AWS Systems Manager - Session Manager
In order to manage and troubleshoot issues with the EKS worker nodes, a bastion host is needed.  AWS Systems Manager comes with a feature under the `Session Manager` that allows you to SSH into any EC2 instance that you configured with the SSM manager.

The EKS worker nodes have been configured with the SSM manager. But they take about 10 minutes to be available in SSM manager. 

### Instances must be have an `Association Status` of `Success`
Under Session Manager's Managed Instances, you can see a list of the EKS nodes.  
Scroll to the right and you'll see the Association Status. It must be `Success` or SSH sessions will fail.  

### Orphan Sessions - must be terminated
Sometimes you will forget to close your SSH session and it will be orphaned. You'll need to use the CLI to terminate the session.

### Terminate SSH Session
In the SSM Sessions Manager History, get the session-id of the session that seems to be in an eternal "terminating state". Then run.  
`aws ssm terminate-session --session-id session-id`

# Open Questions:
Should the RDS aurora cluster have a final_snapshot? Right now is set to YES by setting skip_final_snapshot = false  
Should the RDS aurora cluster DB have delete protection enabled? Right now is set to yes  
Should the RDS aurora cluster DB have encryption enabled? Right now is set to yes  
Should RDS have Enable IAM DB authentication? How will end-users, services, etc authenticate against db?  
Look into AutoScaling Configuration for autoscale policy - what should it be?  
What type of logging should there be in the solution as a whole for EKS, RDS, etc?  
What type of IAM Role permissions will the actual POD based workloads need? They will need their own roles or permissions added to the role running the EKS worker nodes  
Should the EKS Worker EBS volumes be encrypted?  
Should the EKS Cluster Endpoint be private or public?  

# Troubleshooting
* Run `aws sts get-caller-identity` to see who you are logged in as  
* To Assume a role - `aws sts assume-role --role-arn arn:aws:iam::Account_ID:role/ROLE_NAME --role-session-name eks-my-session`  
* If you're authentication is not working, check to see if aws-auth config map is correct. `kubectl -n kube-system get cm aws-auth -o yaml`  


# Sample terraform.tfvars
## Create terraform.tfvars in your root folder with these variables
```
aws_region            = "us-west-2"
vpc_cidr_block = "10.0.0.0/16"
```
The number of subnet cidrs must be equal across the gateway, application and database subnet.  
the gateway subnet cannot have more cidrs than the others and vice-versa  
Many resources are driven by the number of cidrs in the list/array.  
REMOVE THIS SECTION when copying and pasting into your variables file.
```
gateway_subnets     = ["10.0.10.0/24", "10.0.11.0/24"]
application_subnets = ["10.0.20.0/24", "10.0.21.0/24"]
database_subnets    = ["10.0.30.0/24", "10.0.31.0/24"]
aws_access_key        = " your access key"
aws_secret_key        = " your secret key "
subnet_count          = "2"
accessing_computer_ip = "Your Computer's Internet Routable IP"
keypair-name          = "a key pair name from your AWS region where you will deploy this terraform"
hosted_zone_id        = "placeholder-future-use"
domain_name           = "placeholder-future-use"
hosted_zone_url       = "placeholder.io"
cluster_name          = "cluster name "
ec2_ami_image_id      = "ami-00b95829322267382"  You can find this by googline EKS Worker Image
ec2_instance_type     = "m4.large"  You can find this by googline EKS Worker Image
# aurora variables
aurora_db_engine                       = "aurora-postgresql"
aurora_db_backup_retention_period      = 5
aurora_db_preferred_backup_window      = "09:00-10:00"
aurora_db_preferred_maintenance_window = "wed:04:00-wed:04:30"
aurora_db_port                         = 5432
aurora_db_instance_class               = "db.r4.large"
cidr_block                             = "10.0.0.0/16"
cluster_master_username                = ""
cluster_master_password                = ""
copy_tags_to_snapshot   = true
deletion_protection     = true
storage_encrypted       = true
kms_key_id              = "arn:aws:kms:_some_region_:_some_aws_account_:key/_the_arn_for_key"
eks_nodes_desired_capacity = 3
eks_nodes_maximum          = 4
eks_nodes_minimum          = 1
eks_system_master_users    = ["amazon.07.2019", "user1"]
```