module "network" {
  source = "./modules/network"

  // pass variables from .tfvars
  aws_region   = "${var.aws_region}"
  subnet_count = "${var.subnet_count}"
  cluster_name = "${var.cluster_name}"
  cidr_block   = "${var.cidr_block}"
}

module "eks" {
  source = "./modules/eks"

  // pass variables from .tfvars
  accessing_computer_ip      = "${var.accessing_computer_ip}"
  aws_region                 = "${var.aws_region}"
  keypair-name               = "${var.keypair-name}"
  cluster_name               = "${var.cluster_name}"
  domain_name                = "${var.domain_name}"
  ec2_instance_type          = "${var.ec2_instance_type}"
  ec2_ami_image_id           = "${var.ec2_ami_image_id}"
  eks_nodes_desired_capacity = "${var.eks_nodes_desired_capacity}"
  eks_nodes_maximum          = "${var.eks_nodes_maximum}"
  eks_nodes_minimum          = "${var.eks_nodes_minimum}"

  // inputs from modules
  vpc_id             = "${module.network.vpc_id}"
  app_subnet_ids     = "${module.network.app_subnet_ids}"
  gateway_subnet_ids = "${module.network.gateway_subnet_ids}"
}

module "db" {
  source = "./modules/db"

  //pass variables
  # Aurora variables
  aurora_db_engine                       = "${var.aurora_db_engine}"
  aurora_db_name                         = "${var.cluster_name}"
  aurora_db_backup_retention_period      = "${var.aurora_db_backup_retention_period}"
  aurora_db_preferred_backup_window      = "${var.aurora_db_preferred_backup_window}"
  aurora_db_preferred_maintenance_window = "${var.aurora_db_preferred_maintenance_window}"
  aurora_db_instance_class               = "${var.aurora_db_instance_class}"
  aurora_db_port                         = "${var.aurora_db_port}"
  cluster_name                           = "${var.cluster_name}"
  cluster_master_username                = "${var.cluster_master_username}"
  cluster_master_password                = "${var.cluster_master_password}"

  copy_tags_to_snapshot = "${var.copy_tags_to_snapshot}"
  deletion_protection   = "${var.deletion_protection}"
  storage_encrypted     = "${var.storage_encrypted}"
  kms_key_id            = "${var.kms_key_id}"

  // inputs from modules
  vpc_id         = "${module.network.vpc_id}"
  cidr_block     = "${var.cidr_block}"
  app_subnet_ids = "${module.network.app_subnet_ids}"
  app_cidr_block = "${module.network.app_cidr_block}"
  rds_subnet_ids = "${module.network.database_subnet_ids}"
}


#to be added later.
# module "alb" {
#   source = "./modules/alb"
#   // pass variables from .tfvars
#   hosted_zone_id           = "${var.hosted_zone_id}"
#   hosted_zone_url          = "${var.hosted_zone_url}"
#   // inputs from modules
#   vpc_id                  = "${module.network.vpc_id}"
#   gateway_subnet_ids      = "${module.network.gateway_subnet_ids}"
#   node_sg_id              = "${module.eks.node_sg_id}"
#   lb_target_group_arn     = "${module.eks.target_group_arn}"
# }
