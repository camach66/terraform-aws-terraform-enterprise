resource "random_string" "friendly_name" {
  length  = 4
  upper   = false # Some AWS resources do not accept uppercase characters.
  number  = false
  special = false
}

module "secrets" {
  source = "../../fixtures/secrets"
  tfe_license = {
    name = "${local.friendly_name_prefix}-tfe-license"
    path = var.license_file
  }
}

data "aws_iam_user" "ci_s3" {
  user_name = "TFE-S3"
}

module "kms" {
  source        = "../../fixtures/kms"
  key_alias     = "${local.friendly_name_prefix}-key"
  iam_principal = local.iam_principal
}

resource "tls_private_key" "main" {
  algorithm = "RSA"
}

resource "local_file" "private_key_pem" {
  filename = "${path.module}/work/private-key.pem"

  content         = tls_private_key.main.private_key_pem
  file_permission = "0600"
}

resource "aws_key_pair" "main" {
  public_key = tls_private_key.main.public_key_openssh

  key_name = "${local.friendly_name_prefix}-ssh"
}

module "test_proxy" {
  source                          = "../../fixtures/test_proxy"
  subnet_id                       = module.tfe.private_subnet_ids[0]
  key_name                        = var.key_name
  name                            = local.friendly_name_prefix
  http_proxy_port                 = local.http_proxy_port
  mitmproxy_ca_certificate_secret = data.aws_secretsmanager_secret.ca_certificate.arn
  mitmproxy_ca_private_key_secret = data.aws_secretsmanager_secret.ca_private_key.arn

}

module "tfe" {
  source = "../../"

  acm_certificate_arn  = var.acm_certificate_arn
  domain_name          = "tfe-team-dev.aws.ptfedev.com"
  friendly_name_prefix = local.friendly_name_prefix
  tfe_license_secret   = module.secrets.tfe_license

  ami_id                  = data.aws_ami.rhel.id
  aws_access_key_id       = var.aws_access_key_id
  aws_secret_access_key   = var.aws_secret_access_key
  ca_certificate_secret   = data.aws_secretsmanager_secret.ca_certificate.arn
  iact_subnet_list        = ["0.0.0.0/0"]
  iam_role_policy_arns    = [local.ssm_policy_arn, "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
  instance_type           = "m5.xlarge"
  key_name                = aws_key_pair.main.key_name
  kms_key_arn             = module.kms.key
  load_balancing_scheme   = local.load_balancing_scheme
  object_storage_iam_user = data.aws_iam_user.object_storage
  node_count              = 2
  proxy_ip                = "${module.test_proxy.proxy_ip}:${local.http_proxy_port}"
  tfe_subdomain           = local.test_name

  asg_tags = local.common_tags
}

resource "null_resource" "wait_for_instances" {
  triggers = {
    arn = module.tfe.tfe_autoscaling_group.arn
  }

  provisioner "local-exec" {
    command = "sleep 30"
  }
}

resource "local_file" "ssh_config" {
  filename = "${path.module}/work/ssh-config"

  content = templatefile(
    "${path.module}/templates/ssh-config.tpl",
    {
      instance      = data.null_data_source.instance.outputs
      identity_file = local_file.private_key_pem.filename
      user          = local.ssh_user
    }
  )
}
