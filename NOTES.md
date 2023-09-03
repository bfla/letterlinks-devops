# Notes

### One-liner for assuming a role and exporting the variables
```bash
export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" \
          $(aws sts assume-role \
          --role-arn $ROLE_ARN \
          --role-session-name $ROLE_NAME \
          --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" \
          --output text))
```


### Log-in to ECR
```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com
```
