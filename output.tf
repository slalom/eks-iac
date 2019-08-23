output "eks_kubeconfig" {
    value = "${module.eks.eks_kubeconfig}"
}

output "config_map_aws_auth" {
    value = "${module.eks.config_map_aws_auth}"
}
