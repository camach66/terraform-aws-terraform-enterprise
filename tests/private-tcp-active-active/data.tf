data "aws_secretsmanager_secret" "ca_certificate" {
  name = var.ca_certificate_secret_name
}

data "aws_secretsmanager_secret" "ca_private_key" {
  name = var.ca_private_key_secret_name
}

data "aws_ami" "rhel" {
  owners = ["679593333241"] # Amazon RHEL

  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-7.9_HVM-*-x86_64-*-Hourly2-GP2-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
