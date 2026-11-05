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
6. Install Opentofu's v1.13.8 version from [here](https://opentofu.org/docs/intro/install/)
7. Install Terragrunt's latest version from [here](https://terragrunt.gruntwork.io/docs/getting-started/install/)
## Setup

1. Apply the terraform project.
```bash
cd infra/accounts/dev/hello-world; terragrunt init --backend-bootstrap; terragrunt apply -var="release_version=<release_version>"
```
This will output
* URL to access the web server.

## Development
1. Make desired code changes to `src` directory.
2. Run terragrunt with updated release version
```bash
cd infra/accounts/dev/hello-world; terragrunt apply -var="release_version=<release_version>"
```

## TODO
- [ ] Use opentf client side [state encryption](https://www.gruntwork.io/blog/make-the-switch-to-opentofu)
- [ ] Setup CI/CD using [terragrunt-action@v3](https://github.com/gruntwork-io/terragrunt-action)
