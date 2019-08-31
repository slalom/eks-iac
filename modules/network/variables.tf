variable "aws_region" {
 type = "string"
 description = "Used AWS Region."
}

variable "cluster_name" {
    type        = "string"
    description = "The name of the cluster"
}

variable "vpc_cidr_block" {
    type        = "string"
    description = "The vpc cidr block"
  
}

variable "gateway_subnets" {
  type        = "list"
  description = "A map of cidr block ranges for the subnets in the gateway subnet"
}


variable "application_subnets" {
  type        = "list"
  description = "A map of cidr block ranges for the subnets in the application subnet"
}

variable "database_subnets" {
  type        = "list"
  description = "A map of cidr block ranges for the subnets in the database subnet"
}