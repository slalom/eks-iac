# DO NOT ATTEMPT the following unless your cluster admin has already run
1. terraform output config_map_aws_auth >nodes_aws_auth.yml
2. kubectl apply -f nodes_aws_auth.yml 

Otherwise, you'll get `Access denied` or `No resources found` or `You need to login to the server`

# Exporing Your Keys
Open a command prompt and export your keys as follows:
export AWS_ACCESS_KEY_ID="{enter your value here}"
export AWS_SECRET_ACCESS_KEY="{enter your value here}"
export AWS_DEFAULT_REGION="us-west-2" 

## Download your EKS config
Run
`aws eks update-kubeconfig --name your-cluster-name --role-arn arn:aws:iam::111122223333:role/your-role-name`

Examples below use brightloom-cluster as the cluster-name.
## Then Update your ~/.kube/config
1. Edit `~/.kube/config` with your favorate text editor
2. Find the like that looks like the one below for your cluster

```
- name: arn:aws:eks:us-west-2:11112222333:cluster/brightloom-cluster
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      args:
      - token
      - -i
      - brightloom-cluster
      - "-r"
      - "arn:aws:iam::XXXX:role/{your-role-name-here}"
      command: aws-iam-authenticator

3. See example_kube_config.yml line 24-25

## Get an aws-iam-authenticator TOKEN
In this example, the role name will be the one from your cluster (ex: mi-cluster-us-west-2-cluster-root-masters)
Run
`aws-iam-authenticator token -i brightloom-cluster -r arn:aws:iam::11112222333:role/YOUR_AWS_CLUSTER_ROLE`

## You're in
run
`kubectl get svc' or any other of your favorite kubectl commands!