data "aws_secretsmanager_secret" "tfe_license" {
  name = var.tfe_license_secret_name
}

data "aws_secretsmanager_secret" "certificate_pem" {
  name = var.certificate_pem_secret_name
}

data "aws_secretsmanager_secret" "private_key_pem" {
  name = var.private_key_pem_secret_name
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}