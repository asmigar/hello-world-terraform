## Pre-requisites
1. Create an IAM user with Administrator access [here](https://us-east-1.console.aws.amazon.com/iam/home?region=us-east-1#/users)
2. Create Access key for the above user for CLI access. You will find the option under **Security Credentials** tab on the IAM user console.
3. Install aws cli on your machine. Steps [here](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
4. Run `aws configure --profile asmigar`. It will prompt for the Access Key and Secret Access Key you created in Step 2.
```bash
$ aws configure --profile asmigar
AWS Access Key ID [None]: [Enter your access key id here. And then press enter]
AWS Secret Access Key [None]: [Enter your corresponding secret access key here. And then press enter]
Default region name [None]: [You can keep it blank. So just press Enter]
Default output format [None]: [You can keep it blank. So just press Enter]
```
5. Verify your aws creds are configured by running `aws iam list-users --profile asmigar`. You should at least see the admin user you created in step 1.
```bash
$ aws iam list-users --profile asmigar
{
    "Users": [
        {
            "Path": "/",
            "UserName": "SagarM",
            "UserId": "AIDA5FTY6HTRVAX2LBERT",
            "Arn": "arn:aws:iam::905417997539:user/SagarM",
            "CreateDate": "2024-03-26T11:11:14+00:00",
            "PasswordLastUsed": "2024-04-01T04:59:30+00:00"
        }
    ]
}
```
6. Install Terraform's latest version from [here](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
7. Install Terragrunt's latest version from [here](https://terragrunt.gruntwork.io/docs/getting-started/install/)
## Setup

1. Apply the `remote_state` terraform project. This will create s3 bucket and lock table for keeping remote state for other tf projects.
```bash
cd infra/accounts/dev/remote_state; terraform init; terraform apply
```
2. Apply the `ecs` terraform project.
```bash
cd infra/accounts/dev/hello-world; terragrunt init; terragrunt apply
```
This will output
* URL to access the web server.
* ECR repo url where docker images should be pushed.

## Development
1. Make desired code changes to `src` directory.
2. Run docker build
```bash
cd src; docker build -t <docker_ecr_repo_url>:<version> .
```
3. Docker login into the ECR repo
```bash
aws ecr get-login-password --region us-east-1 --profile asmigar | docker login --username AWS --password-stdin <ecr_repo_url>
```
4. Publish docker image 
```bash
docker push <docker_ecr_repo_url>:<version>
```
5. Apply the `ecs` terraform project with the version provided in above step
```bash
cd infra/accounts/dev/ecs; terragrunt apply -var="release_version=<release_version>"
```

## TODO
- Create GithubActions for CI/CD 
