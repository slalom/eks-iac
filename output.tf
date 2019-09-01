output "eks_kubeconfig" {
  value = "${module.eks.eks_kubeconfig}"
}

output "config_map_aws_auth" {
  value = "${module.eks.config_map_aws_auth}"
}

output "cluster_root_admin_role" {
  value = "${module.eks.cluster_root_admin_role}"
}

output "cluster_root_admin_role_arn" {
  value = "${module.eks.cluster_root_admin_role_arn}"
}
