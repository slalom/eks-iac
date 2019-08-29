variable "aws_region" {
  type        = "string"
  description = "Used AWS Region."
}

variable "aws_access_key" {
  type        = "string"
  description = "The account identification key used by your Terraform client."
}

variable "aws_secret_key" {
  type        = "string"
  description = "The secret key used by your terraform client to access AWS."
}

variable "subnet_count" {
  type        = "string"
  description = "The number of subnets we want to create per type to ensure high availability."
}

variable "accessing_computer_ip" {
  type        = "string"
  description = "IP of the computer to be allowed to connect to EKS master and nodes."
}

variable "keypair-name" {
  type        = "string"
  description = "Name of the keypair declared in AWS IAM, used to connect into your instances via SSH."
}

variable "hosted_zone_id" {
  type        = "string"
  description = "ID of the hosted Zone created in Route53 before Terraform deployment."
}

variable "hosted_zone_url" {
  type        = "string"
  description = "URL of the hosted Zone created in Route53 before Terraform deployment."
}

# cluster_name will be given to EKS and Aurora_Cluster
variable "cluster_name" {
  type        = "string"
  description = "Name of the cluster - will be used to name and tag resources"
}

variable "domain_name" {
  type        = "string"
  description = "Name of the domain for R53, certificate and domains"
}

variable "ec2_instance_type" {
  type        = "string"
  description = "EC2 instance type (t2.small,etc) for the eks worker"
  default     = "m4.large"
}

variable "ec2_ami_image_id" {
  type        = "string"
  description = "EC2 regional AMI ID for the eks worker"
}

# Aurora variables
variable "aurora_db_engine" {
  type        = "string"
  description = "ex: aurora, aurora-mysql, aurora-postgresql"
}

variable "aurora_db_instance_class" {
  type        = "string"
  description = "ex: db.r4.large"
}

variable "aurora_db_backup_retention_period" {
  default     = 1
  description = "1 through 35"
}

variable "aurora_db_preferred_backup_window" {
  type        = "string"
  description = "ex: 07:00-09:00"
}

variable "aurora_db_preferred_maintenance_window" {
  type        = "string"
  description = "The weekly time range during which system maintenance can occur, in (UTC) e.g. wed:04:00-wed:04:30"
}

variable "aurora_db_port" {
  default     = 5432
  description = "The port on which the DB accepts connections (ex: 3306 for MySQL, 5432 for PostgreSQL)"
}


variable "cluster_master_username" {
  type = "string"
}
variable "cluster_master_password" {
  type = "string"
}

variable "cidr_block" {
  type        = "string"
  description = "VPC cidr_block"
}

variable "copy_tags_to_snapshot" {
  description = "Copy all Cluster tags to snapshots. Default is false."
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled. The database can't be deleted when this value is set to true. The default is false."
}

variable "storage_encrypted" {
  description = "Specifies whether the DB cluster is encrypted. The default is false for provisioned engine_mode and true for serverless engine_mode."
}

variable "kms_key_id" {
  type        = "string"
  description = "The ARN for the KMS encryption key. When specifying kms_key_id, storage_encrypted needs to be set to true."
}

variable "eks_nodes_desired_capacity" {
  description = "This is the desired autoscaling group desired capacity of worker nodes to start with"
}

variable "eks_nodes_maximum" {
  description = "This is the desired autoscaling group maximum number of worker nodes"
}

variable "eks_nodes_minimum" {
  description = "This is the desired autoscaling group minimum number of worker nodes"
}
