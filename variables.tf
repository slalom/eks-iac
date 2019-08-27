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

variable "aurora_db_az_zones" {
  type        = "string"
  description = "ex: us-west-2a, us-west-2b, us-west-2c"
}

variable "aurora_db_backup_retention_period" {
  type        = number
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
  type        = number
  default     = 5432
  description = "The port on which the DB accepts connections (ex: 3306 for MySQL, 5432 for PostgreSQL)"
}

variable "cidr_block" {
  type        = "string"
  description = "VPC cidr_block"
}


/*
copy_tags_to_snapshot – (Optional, boolean)

deletion_protection - (Op
final_snapshot_identifier - (Optional) The name of your final DB snapshot when this DB cluster is deleted. If omitted, no final snapshot will be made.
port - (O
storage_encrypted - (Optional) Specifies whether the DB cluster is encrypted. The default is false for provisioned engine_mode and true for serverless engine_mode.
kms_key_id - (Optional) The ARN for the KMS encryption key. When specifying kms_key_id, storage_encrypted needs to be set to true.
enabled_cloudwatch_logs_exports - (Optional) List of log types to export to cloudwatch. If omitted, no logs will be exported. The following log types are supported: audit, error, general, slowquery, postgresql (PostgreSQL).

*/