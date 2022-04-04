data "aws_secretsmanager_secret" "tfe_license" {
  name = var.tfe_license_secret_name
}

data "aws_secretsmanager_secret" "certificate_pem" {
  name = var.certificate_pem_secret_name
}

data "aws_secretsmanager_secret" "private_key_pem" {
  name = var.private_key_pem_secret_name
}

data "aws_ami" "rhel" {
  owners = ["309956199498"] # RedHat

  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-7.9_HVM-*-x86_64-*-Hourly2-GP2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}