variable "vpc_id" {
  type = "string"
}

variable "accessing_computer_ip" {
    type = "string"
    description = "Public IP of the computer accessing the cluster via kubectl or browser."
}

variable "aws_region" {
  type = "string"
  description = "WIP: List of used aws_regions. Should be a single one, might not be used at all."
}

variable "keypair-name" {
  type = "string"
}

variable "app_subnet_ids" {
  type = "list"
}


variable "gateway_subnet_ids" {
  type = "list"
  description = "List containing the IDs of all created gateway subnets."
}


variable "cluster_name" {
  type = "string"
}

variable "domain_name" {
  type = "string"
}

variable "ec2_instance_type" {
  type        = "string"
  description = "EC2 instance type (t2.small,etc) for the eks worker"
}

variable "ec2_ami_image_id" {
  type        = "string"
  description = "EC2 regional AMI ID for the eks worker"
}

variable "eks_nodes_desired_capacity" {
  description = "This is the desired autoscaling group desired capacity of worker nodes to start with"
}

variable "eks_nodes_maximum" {
  description = "This is the desired autoscaling group max capacity of worker nodes"
}

variable "eks_nodes_minimum" {
  description = "This is the desired autoscaling group minimum number of worker nodes"
}