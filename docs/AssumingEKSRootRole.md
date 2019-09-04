# DO NOT ATTEMPT the following unless your cluster CREATOR has run the following
These two commands must be run by the cluster creator in order to provide you access.

1. terraform output config_map_aws_auth >nodes_aws_auth.yml
2. kubectl apply -f nodes_aws_auth.yml 

Otherwise, you'll get `Access denied` or `No resources found` or `You need to login to the server`

Once you confirm, move on to next steps.

# Tooling pre-reqs
## You must have the following installed
1. aws CLI (python3.7 and pip3)
2. aws-aim-authenticator (https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)
3. kubectl (https://kubernetes.io/docs/tasks/tools/install-kubectl/)

# Exporing Your Keys
Open a command prompt and export your keys as follows:  
export AWS_ACCESS_KEY_ID="{enter your value here}"  
export AWS_SECRET_ACCESS_KEY="{enter your value here}"  
export AWS_DEFAULT_REGION="us-west-2"  

## Download your EKS config
This step assumes you have been given acces to a EKS:* role and that you actually have access to EKS.  
By default, terraform creates a {cluster-name}-{aws-region}-cluster-root-masters role.  You should have acces to assume this role.

Your cluster creator admin will provide you this role arn.

Run
`aws eks update-kubeconfig --name your-cluster-name --role-arn arn:aws:iam::111122223333:role/your-role-name`

Examples below use `slalom-cluster` as the cluster-name.
## Then Update your ~/.kube/config
1. Edit `~/.kube/config` with your favorate text editor
2. Find the like that looks like the one below for your cluster

```
- name: arn:aws:eks:us-west-2:11112222333:cluster/slalom-cluster
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      args:
      - token
      - -i
      - slalom-cluster
      - "-r"
      - "arn:aws:iam::XXXX:role/{your-role-name-here}"
      command: aws-iam-authenticator
```

3. See *docs/example_kube_config.yml* line 24-25

## Get an aws-iam-authenticator TOKEN

In this example, the role name will be the one from your cluster (ex: mi-cluster-us-west-2-cluster-root-masters)

Run
`aws-iam-authenticator token -i slalom-cluster -r arn:aws:iam::11112222333:role/your-role-name`

## You're in
run
`kubectl get svc' or any other of your favorite kubectl commands!
