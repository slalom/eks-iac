data "aws_region" "current" {}

# Setup for IAM role needed to setup an EKS cluster
resource "aws_iam_role" "tf-eks-master" {
  name = "${var.cluster_name}-eks-master-cluster"
  description = "This is the role assign to the cluster to the console/AWS and k8s CLI"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "tf-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.tf-eks-master.name}"
}

resource "aws_iam_role_policy_attachment" "tf-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.tf-eks-master.name}"
}

########################################################################################
# Setup IAM role & instance profile for worker nodes

resource "aws_iam_role" "tf-eks-node" {
  name = "terraform-eks-tf-eks-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "tf-eks-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.tf-eks-node.name}"
}

resource "aws_iam_role_policy_attachment" "tf-eks-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.tf-eks-node.name}"
}

resource "aws_iam_role_policy_attachment" "tf-eks-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.tf-eks-node.name}"
}

# These two policies below allow for SSH connections into 
# the worker nodes via the SSM Session Manager
# Read: https://aws.amazon.com/blogs/infrastructure-and-automation/toward-a-bastion-less-world/
 
resource "aws_iam_role_policy_attachment" "tf-eks-node-CloudWatchAgentServerPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = "${aws_iam_role.tf-eks-node.name}"
}

# This is to be able to ssh via SSM
resource "aws_iam_role_policy_attachment" "tf-eks-node-AmazonSSMManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = "${aws_iam_role.tf-eks-node.name}"
}

# END SSH SSM Session Manager Policies

resource "aws_iam_instance_profile" "node" {
  name = "terraform-eks-node"
  role = "${aws_iam_role.tf-eks-node.name}"
}

#   BEGING  cluster default roles for day-to-day kubectl operations
# The following are the default roles to grant others access to the cluster
# These roles must be associated with the proper EKS k8s role and rolebinding
# Note that these roles do not have any access to AWS Console itself. 
# The roles are meant for kubectl operations against cluster.
# We also want this role specific for RBAC permissions to the k8s CLI

resource "aws_iam_role" "tf-eks-cluster-root-masters" {
  name = "${var.cluster_name}-${data.aws_region.current.name}-cluster-root-masters"
  description = "This is the ROOT - super-user access to perform any action on any resource. It will give full control over everything"

# Note that this role does not have any permissions outside of the role policy
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
  tags = {
    Name = "${var.cluster_name}-${data.aws_region.current.name}-cluster-root-masters"
  }
}

# END cluster default roles for day-to-day kubectl operations