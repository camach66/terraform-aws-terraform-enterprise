# Terraform Enterprise: High Availability for AWS (BETA)

![Terraform Logo](https://github.com/hashicorp/terraform-aws-terraform-enterprise/blob/master/assets/TerraformLogo.png?raw=true)

## Description

This module installs Terraform Enterprise HA BETA onto 1 or more aws instances in DEMO mode. All data is stored on the instance(s) and is not preserved.

## Architecture

![basic diagram](https://github.com/hashicorp/terraform-aws-terraform-enterprise/blob/v0.0.1-beta/assets/aws_diagram.jpg?raw=true)
_example architecture_

Please contact your Technical Account Manager for more information, and support for any issues you have.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| distribution | Type of linux distribution to use. (ubuntu or rhel) | string | n/a | yes |
| domain | Route53 Domain to manage DNS under | string | n/a | yes |
| license\_file | path to Replicated license file | string | n/a | yes |
| primary\_count | The number of additional cluster master nodes to run | string | n/a | yes |
| secondary\_count | The number of secondary cluster nodes to run | string | n/a | yes |
| vpc\_id | AWS VPC id to install into | string | n/a | yes |
| ca_cert_url | URL to CA certificate file used for the internal `ptfe-proxy` used for outgoing connections| string | `"none"` | no |
| airgap\_installer\_url | URL to replicated's airgap installer package | string | `"https://install.terraform.io/installer/replicated-v5.tar.gz"` | no |
| airgap\_package\_url | signed URL to download the package | string | `""` | no |
| ami | AMI to launch instance with; defaults to latest Ubuntu Xenial | string | `""` | no |
| aws\_access\_key\_id | AWS access key id to connect to s3 with | string | `""` | no |
| aws\_secret\_access\_key | AWS secret access key to connect to s3 with | string | `""` | no |
| cert\_domain | domain to search for ACM certificate with (default is *.domain) | string | `""` | no |
| cidr | cidr block for vpc | string | `"10.0.0.0/16"` | no |
| encryption\_password | encryption password to use as root secret (default is autogenerated) | string | `""` | no |
| external\_services | object store provider for external services. Allowed values: aws | string | `""` | no |
| hostname | hostname to assign to cluster under domain (default is autogenerated one) | string | `""` | no |
| http\_proxy\_url | HTTP(S) Proxy URL | string | `""` | no |
| iact\_subnet\_list | List of subnets to allow to access Initial Admin Creation Token (IACT) API. https://www.terraform.io/docs/enterprise/private/automating-initial-user.html | string | `""` | no |
| iact\_subnet\_time\_limit | Amount of time to allow access to IACT API after initial boot | string | `""` | no |
| import\_key | an ssh pub key to import to all machines | string | `""` | no |
| install\_mode | Installation mode | string | `"demo"` | no |
| postgresql\_address | address to connect to external postgresql database at | string | `""` | no |
| postgresql\_database | database name to use in exetrnal postgresql database | string | `""` | no |
| postgresql\_extra\_params | additional connection string parameters (must be url query params) | string | `""` | no |
| postgresql\_password | password to connect to external postgresql database as | string | `""` | no |
| postgresql\_user | user to connect to external postgresql database as | string | `""` | no |
| primary\_instance\_type | ec2 instance type | string | `"m4.xlarge"` | no |
| ptfe\_url | URL to the PTFE tool | string | `"https://install.terraform.io/installer/ptfe.zip"` | no |
| region | aws region where resources will be created | string | `"us-west-2"` | no |
| s3\_bucket | S3 bucket to store objects into | string | `""` | no |
| s3\_region | Region of the S3 bucket | string | `""` | no |
| secondary\_instance\_type | ec2 instance type (Defaults to `primary_instance_type` if not set.) | string | `""` | no |
| ssh\_user | the user to connect to the instance as | string | `""` | no |
| startup\_script | shell to run when primary instance boots | string | `""` | no |
| subnet\_tags | tags to use to match subnets to use | map | `{}` | no |
| update\_route53 | whether or not to automatically update route53 records for the cluster | string | `"true"` | no |
| volume\_size | size of the root volume in gb | string | `"100"` | no |
| whitelist | List of CIDRs we allow to access the PTFE infrastructure | list | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| iam\_role | The name of the IAM role being used |
| install\_id | The installation ID for TFE |
| lb\_endpoint | The load-balancer endpoint URI |
| primary\_public\_ip | The public IP address of the primary VMs |
| ptfe\_endpoint | The accessible PTFE URI |
| ptfe\_health\_check | The PTFE URI used for the health check |
| replicated\_console\_password | The Replicated console password |
| replicated\_console\_url | The Replicated Console URL |
| ssh\_config\_file | The path to the SSH configuration file |
| ssh\_private\_key | The SSH private key |

