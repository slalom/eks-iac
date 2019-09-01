# Exporing Your Keys
Open a command prompt and export your keys as follows:
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_DEFAULT_REGION="us-west-2" 

## Download your EKS config
Run
`aws eks update-kubeconfig --name {cluster-name}`

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
      command: aws-iam-authenticator
```
3. Add the following after the -cluster line as such  
* - "-r"
* - "arn:aws:iam::XXXX:role/fitcycleEastAdmin"

4. See example_kube_config.yml line 24-25

## Get an aws-iam-authenticator TOKEN
In this example, the role name
Run
`aws-iam-authenticator token -i brightloom-cluster -r arn:aws:iam::11112222333:role/YOUR_AWS_CLUSTER_ROLE`

## You're in
run
`kubectl get svc' or any other of your favorite kubectl commands!