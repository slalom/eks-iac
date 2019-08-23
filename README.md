# eks-iac

## aws-iam-authenticator installation

This is required to ensure terraform plans successfully.

* brew install aws-iam-authenticator
* https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html

## Connecting to the cluster
Run:
aws eks --region region update-kubeconfig --name cluster_name
### To Swtich Context
kubectl config use-context context-name

