echo "Backing up aws config and credential files"
cp ~/.aws/config ~/.aws/config_backup && cp ~/.aws/credentials ~/.aws/credentials_backup
echo "Assuming role and getting the session"
#       UPDATE your Account NUMBER BELOW BAD - 111122223333
#                    ROLE NAME
#                    ROLE SESSION NAME as needed.
aws sts assume-role --role-arn arn:aws:iam::111122223333:role/slalom-us-west-2-cluster-root-masters --role-session-name eks-admin > assume-role-output.json
echo "Setting the AWS_ACCESS_KEY_ID to env var"
export AWS_ACCESS_KEY_ID=$(jq -r '.Credentials.AccessKeyId' assume-role-output.json)
echo "Setting the AWS_SECRET_ACCESS_KEY to env var"
export AWS_SECRET_ACCESS_KEY=$(jq -r '.Credentials.SecretAccessKey' assume-role-output.json)
echo "Setting the AWS_SESSION_TOKEN to env var"
export AWS_SESSION_TOKEN=$(jq -r '.Credentials.SessionToken' assume-role-output.json)
export apples="a-file-name"
echo "Removing Temporary files"
rm assume-role-output.json
