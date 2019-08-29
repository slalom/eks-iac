/*
This file was commented out since it keeps on timing out.
Note that this is not the supported terraform way of having the nodes join the cluster anyway.

Error: 

Post https://71724F85A3034DE06A99ECA130CFC31D.sk1.us-west-2.eks.amazonaws.com/api/v1/namespaces/kube-system/configmaps: 
dial tcp 52.27.245.203:443: i/o timeout

  on modules/eks/allow_nodes.tf line 17, in resource "kubernetes_config_map" "aws_auth":
  17: resource "kubernetes_config_map" "aws_auth" {
      
*/

########################################################################################
# setup provider for kubernetes

# data "external" "aws_iam_authenticator" {
#   program = ["sh", "-c", "aws-iam-authenticator token -i ${var.cluster_name}-cluster | jq -r -c .status"]
# }

# provider "kubernetes" {
#   host                      = "${aws_eks_cluster.tf_eks.endpoint}"
#   cluster_ca_certificate    = "${base64decode(aws_eks_cluster.tf_eks.certificate_authority.0.data)}"
#   token                     = "${data.external.aws_iam_authenticator.result.token}"
#   load_config_file          = false
#   version = "~> 1.7"
# }

# # Allow worker nodes to join cluster via config map
# resource "kubernetes_config_map" "aws_auth" {
#   metadata {
#     name = "aws-auth"
#     namespace = "kube-system"
#   }
#   data = {
#     mapRoles = <<EOF
# - rolearn: ${aws_iam_role.tf-eks-node.arn}
#   username: system:node:{{EC2PrivateDNSName}}
#   groups:
#     - system:bootstrappers
#     - system:nodes
# EOF
#   }
#   depends_on = [
#     "aws_eks_cluster.tf_eks"  ] 
# }
