
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

variable "aurora_db_az_zones" {
  type        = "string"
  description = "ex: us-west-2a, us-west-2b, us-west-2c"
}

variable "aurora_db_name" {
  type        = "string"
  description = "database name"
}

variable "aurora_db_backup_retention_period" {
  type        = number
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
  type = number
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



