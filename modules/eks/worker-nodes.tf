########################################################################################
# Setup AutoScaling Group for worker nodes

# Setup data source to get amazon-provided AMI for EKS nodes
data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}

# Is provided in demo code, no idea what it's used for though! TODO: DELETE
# data "aws_region" "current" {}

# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We utilize a Terraform local here to simplify Base64 encode this
# information and write it into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
locals {
  tf-eks-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
sudo systemctl status amazon-ssm-agent
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.tf_eks.endpoint}' --b64-cluster-ca '${aws_eks_cluster.tf_eks.certificate_authority.0.data}' '${var.cluster_name}-cluster'
sudo systemctl restart kubelet.service
USERDATA
}

resource "aws_launch_configuration" "tf_eks" {
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.node.name}"
  #image_id                    = "${data.aws_ami.eks-worker.id}"
  image_id                    = "ami-00b95829322267382"
  #instance_type               = "m4.large"
  instance_type               = "m4.large"
  name_prefix                 = "terraform-eks"
  security_groups             = ["${aws_security_group.tf-eks-node.id}"]
  user_data_base64            = "${base64encode(local.tf-eks-node-userdata)}"
  key_name                    = "${var.keypair-name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "tf_eks" {
  name = "terraform-eks-nodes"
  port = 31742
  protocol = "HTTP"
  vpc_id = "${var.vpc_id}"
  target_type = "instance"
}

resource "aws_autoscaling_group" "tf_eks" {
  desired_capacity     = "2"
  launch_configuration = "${aws_launch_configuration.tf_eks.id}"
  max_size             = "3"
  min_size             = 1
  name                 = "terraform-tf-eks"
  vpc_zone_identifier  = "${var.app_subnet_ids}"
  target_group_arns    = ["${aws_lb_target_group.tf_eks.arn}"]
  
  tag {
    key                 = "Name"
    value               = "terraform-tf-eks"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}-cluster"
    value               = "owned"
    propagate_at_launch = true
  }

    tag {
    key                 = "role"
    value               = "eks-worker"
    propagate_at_launch = true
  }

}
