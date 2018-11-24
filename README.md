# Enterprise Development and Deployment


- An auto scaling ECS managed  web application
- Mongo 
- Best practices (mostly) Terraform
- Apps use Secure KeyValue Params
- Consul/Registator Automatic Service Discovery
- NAT Gateway (Ami base to reduce cost)
- Public/Private Subnets across 2 AZ's
- VPN
- Bastion Jump Box Instance for Debugging
* Cloudwtach Logging for most features
* Multi AZ with EFS & RDS Storage
* Encrypted State (no Locking enabled)
* Secure keyless Key,Value store

AWS Infra
![Paddle Planner](https://raw.githubusercontent.com/codecrunchers/paddle-planner-infra/master/docs/paddle-planner-infra.png "Paddle Planner Infra")

## N.B. Change Passwords and configure/review security for public facing Pipeline components such as Jenkins/Nexus/Sonar

## Initial Setup
```bash
export BUCKET_NAME="my.bucket.unique.id-$(uuidgen)"
export DYNAMO_TABLE="my.bucket.unique.id-lock-$(uuidgen)"
```
Some manual steps at the moment, we're working on these.  Using terraform 0.9.11,  so no workspaces for now.


## Initialising state and deploying via Terraforming
Install terraform

### S3/Terraform Backend

```bash
git clone <this repo>
cd app-infra
terraform get
terraform init
```
[<import state>](#state)

Run an `aws s3 ls` before you start for a sanity check.

#### If you get errors 
Some of the config is a little tricky - try these Manual CLI Steps (or do the same  via Web Console)
1. [Create your `S3` bucket](#s3) for state management, (enable Versioning & encryption) this is the value of bucket in `statefile.tf`
2. [Create your `DynamoDB` instance](#dynamo), again matching the names in `statefile.tf` - same as Step 1
3. [Create a keypair](#keypair), matching the name to the value of `key_name` in `terraform.tfstate` save the .pem file as shown below.


### <a name="state"></a> Importing State
```
terraform import aws_s3_bucket.statefiles_for_app "$BUCKET_NAME"
terraform import aws_dynamodb_table.terraform_statelock "$DYNAMO_TABLE"

```

### Plan and Apply (this will cost money)
```bash
terraform plan
terraform apply
```

### Pipeline Service Images

Tag and push your mongo and webapplications (see the terraform.tfvars) to the ecr repositories created. `["app-webapp", "app-mongo"]`

### Services
Once these have been pushed, the ALB Endpoint which appeared in the output of `terraform apply` can be accessed from you vpn on:
* WebAppcan be accessed at http://your-domain/)

#### VPN
* [OpenVPN AMI Docs] (https://docs.openvpn.net/how-to-tutorialsguides/virtual-platforms/amazon-ec2-appliance-ami-quick-start-guide/)

Manually allow your own ip for a single ssh session. SSH in via the key we produced at the start, and run through the cli prompts - takes about 2 mns. At the end do a `sudo passwd openvpn` - you can now hit the HTTPS port of this machine and download your VPN config file.

We'll likely update this, looking for something cheaper/better integrated

#### Debug Box / Bastion / Jump Box
From there, you can access the Debug box, this has access to the entire VPC.



## AWS Commands for Manual Steps
### <a name="s3"></a> S3
`aws s3 mb s3://"$BUCKET_NAME"` (Manually enable & then check for Versioning?) `aws s3api get-bucket-versioning  --bucket <bucket_name_from_statefile.tf>`

### <a name="keypair"></a> Keypair
```bash
aws ec2 create-key-pair --key-name <variables.tf.key_name> --query 'KeyMaterial' --output text > <variables.tf.key_name>.pem
chmod 400 pipeline-ecs.pem
```


