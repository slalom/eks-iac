module "network" {
  source = "./modules/network"

  // pass variables from .tfvars
  aws_region   = "${var.aws_region}"
  subnet_count = "${var.subnet_count}"
  cluster_name = "${var.cluster_name}"
}

module "eks" {
  source = "./modules/eks"

  // pass variables from .tfvars
  accessing_computer_ip = "${var.accessing_computer_ip}"
  aws_region            = "${var.aws_region}"
  keypair-name          = "${var.keypair-name}"
  cluster_name          = "${var.cluster_name}"
  domain_name           = "${var.domain_name}"
  ec2_instance_type     = "${var.ec2_instance_type}"
  ec2_ami_image_id      = "${var.ec2_ami_image_id}"

  // inputs from modules
  vpc_id             = "${module.network.vpc_id}"
  app_subnet_ids     = "${module.network.app_subnet_ids}"
  gateway_subnet_ids = "${module.network.gateway_subnet_ids}"
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
