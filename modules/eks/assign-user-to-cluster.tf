# Adds users to the tf-eks-cluster-root-masters
resource "aws_iam_policy" "assume-root-master" {
  name        = "${var.cluster_name}-assume-root-masters-role"
  path        = "/"
  description = "${var.cluster_name}-assume-root-masters-role used to manage cluster by people other than cluster creator."

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource":  "${aws_iam_role.tf-eks-cluster-root-masters.arn}"
        }
    ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "attach-users-to-systems-master-role" {
    count = "${length(var.eks_system_master_users)}"
    user       = "${element(var.eks_system_master_users, count.index)}"
    policy_arn = "${aws_iam_policy.assume-root-master.arn}"
}