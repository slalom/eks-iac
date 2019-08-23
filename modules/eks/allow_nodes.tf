########################################################################################
# setup provider for kubernetes

data "external" "aws_iam_authenticator" {
  program = ["sh", "-c", "aws-iam-authenticator token -i brightloom | jq -r -c .status"]
}

data "aws_eks_cluster" "eks_cluster" {
  name = "${var.cluster_name}-cluster"
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = "${var.cluster_name}-cluster"
}

provider "kubernetes" {
  host                   = "${data.aws_eks_cluster.eks_cluster.endpoint}"
  cluster_ca_certificate = "${base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority.0.data)}"
  token                  = "${data.aws_eks_cluster_auth.cluster_auth.token}"
  load_config_file       = false
  version = "~> 1.7"
}

# Allow worker nodes to join cluster via config map
resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name = "aws-auth"
    namespace = "kube-system"
  }
  data = {
    mapRoles = <<EOF
- rolearn: ${aws_iam_role.tf-eks-node.arn}
  username: system:node:{{EC2PrivateDNSName}}
  groups:
    - system:bootstrappers
    - system:nodes
EOF
  }
  depends_on = [
    "aws_eks_cluster.tf_eks"  ] 
}