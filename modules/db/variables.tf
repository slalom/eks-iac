
# Aurora variables

# database name
variable "cluster_name" {
  type        = "string"
  description = "Name of the cluster - will be used to name and tag resources"
}

variable "aurora_db_engine" {
  type        = "string"
  description = "Either aurora-postgresql or aurora-mysql"
}

variable "aurora_db_instance_class" {
  type        = "string"
  description = "ex: db.r4.large"
}

variable "aurora_db_name" {
  type        = "string"
  description = "database name"
}

variable "aurora_db_backup_retention_period" {
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
  description = "The port on which the DB accepts connections (ex: 3306 for MySQL, 5432 for PostgreSQL)"
}

variable "vpc_id" {
  type = "string"
}

variable "cidr_block" {
  type = "string"
  description = "VPC cidr_block" 
}

variable "app_cidr_block" {
  type = "list"
  description = "EKS application layer cidr_block" 
}

variable "app_subnet_ids" {
  type = "list"
}

variable "rds_subnet_ids" {
  type = "list"
}

variable "cluster_master_username" {
  type = "string"
}
variable "cluster_master_password" {
  type = "string"
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