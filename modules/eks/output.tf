output "eks_kubeconfig" {
  value = "${local.kubeconfig}"
  depends_on = [
    "aws_eks_cluster.tf_eks"
  ]
}

output "target_group_arn" {
  value = "${aws_lb_target_group.tf_eks.arn}"
}

output "node_sg_id" {
  value = "${aws_security_group.tf-eks-node.id}"
}

output "config_map_aws_auth" {
  value = "${local.config_map_aws_auth}"
  depends_on = [
    "aws_eks_cluster.tf_eks"
  ]
}

# This is the name of the AWS role with full ROOT admin power. People can assume it to get access via the k8s CLI
output "cluster_root_admin_role" {
  value = "${aws_iam_role.tf-eks-cluster-root-masters.name}"
}

output "cluster_root_admin_role_arn" {
  value = "${aws_iam_role.tf-eks-cluster-root-masters.arn}"
}