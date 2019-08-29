# This terraform templates (IaC) creates:
1. VPC
2. 3 Subnets (web (Internet Gateway), app (EKS) and db (Aurora RDS))
3. EKS Cluster
4. EKS Worker Nodes (configurable via variables)
5. Session manager to SSH into worker nodes
6. Aurora RDS (engine and instance configurable)

# Tooling pre-reqs
## You must have the following installed
1. aws CLI (python3.7 and pip3)
2. aws-aim-authenticator (https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)
3. eksctl

# To run the terraform script
## Ensure you have a terraform.tfvars, then run
1. terraform plan
2. terraform apply

## Connecting to the cluster
Run:
aws eks --region region update-kubeconfig --name cluster_name
### To Swtich Context
kubectl config use-context context-name

Then run `kubectl get svc` and you will see your cluster.

## Wiring up Worker Node Access
Currently Terraform doesn't have a built-in way of joining the worker nodes. There is a proposed way to do it via the kubernetes provider which is implemented but it usually times out.  When it times out, you can run terraform apply again and it works the second time.

### Terraform's official Doc on Nodes Joining
Run 
1. terraform output config_map_aws_auth >nodes_aws_auth.yml
2. kubectl apply -f nodes_aws_auth.yaml
3. kubectl get nodes --watch

You'll see the nodes come online

# Terminate SSH Session
In the SSM Sessions Manager History, get the session-id of the session that seems to be in an eternal "terminating state". Then run.
aws ssm terminate-session --session-id session-id

# Open Questions:
Should the RDS aurora cluster have a final_snapshot? Right now defaults to YES by setting skip_final_snapshot = false
Should the RDS aurora cluster DB have delete protection enabled?
Should RDS have Enable IAM DB authentication? How will end-users, services, etc authenticate against db?

# Sample terraform.tfvars
## Create terraform.tfvars in your root folder with these variables

aws_region            = "us-west-2"
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
cidr_block                             = "10.0.0.0/16"
cluster_master_username                = ""
cluster_master_password                = ""