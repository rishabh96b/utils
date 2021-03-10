## Pre-requisites
You should have aws profile set up locally and must have permission to delete vpcs.

## Usage

Get all the vpcs in the specified aws region
```bash
aws ec2 describe-vpcs --region us-east-1 | jq . | grep VpcId
```
Use `clean-vpc.sh` to clean the desired vpc
```bash
# ./clean-vpc.sh  <aws-region> <vpc-id>
./clean-vpc.sh us-east-1 <vpc-xxxxxxxxx>
```
