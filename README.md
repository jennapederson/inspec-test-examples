# InSpec Test Examples

This repository contains three InSpec test examples:

- testing a manually configured IAM user
- testing an AWS CloudFormation managed S3 Bucket
- testing a Terraform managed EC2 + RDS full stack environment

## Provision Cloud Resources

### AWS CloudFormation

To provision the CloudFormation stacks:

    $ aws cloudformation create-stack --stack-name <stack-name> --template-body file://cloudformation/01_s3.yaml

### Terraform

To provision the resources with Terraform, from the `terraform` directory:

    $ terraform apply

## Test Cloud Resources with InSpec

InSpec tests live in the `test` folder and can be run at the command line with InSpec.

### Install InSpec

Follow the directions [here](https://docs.chef.io/inspec/install/) to install InSpec.

### Verify Your InSpec Setup

To verify your InSpec setup for AWS:

    $ inspec detect -t aws://

or with a specific AWS region/profile:
  
    $ inspec detect -t aws://<aws-region>/<aws-profile>

### Run Tests

To run the InSpec tests against your AWS infrastructure:

    $ inspec exec test -t aws://

or with a specific AWS region/profile:

    $ inspec exec test -t aws://<aws-region>/<aws-profile>

### Use Terraform Outputs

For example 3, you'll need to use outputs from your Terraform config files as inputs to your InSpec tests. From the `terraform` directory:

    $ mkdir ../test/files
    $ terraform output --json > ../test/files/terraform.json

and then run the InSpec tests.

## More About InSpec

Learn more about using InSpec to test your cloud resources [here](https://docs.chef.io/inspec/).