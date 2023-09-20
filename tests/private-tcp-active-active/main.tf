# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  assume_role {
    role_arn = var.aws_role_arn
  }

  default_tags {
    tags = local.common_tags
  }
}

resource "random_string" "friendly_name" {
  length  = 4
  upper   = false # Some AWS resources do not accept uppercase characters.
  number  = false
  special = false
}

module "secrets" {
  count  = local.utility_module_test ? 0 : 1
  source = "../../fixtures/secrets"

  tfe_license = {
    name = "${local.friendly_name_prefix}-tfe-license"
    path = var.license_file
  }
}

module "kms" {
  source    = "../../fixtures/kms"
  key_alias = "${local.friendly_name_prefix}-key"
}

module "test_proxy" {
  source                          = "../../fixtures/test_proxy"
  subnet_id                       = module.private_tcp_active_active.private_subnet_ids[0]
  name                            = local.friendly_name_prefix
  key_name                        = var.key_name
  mitmproxy_ca_certificate_secret = data.aws_secretsmanager_secret.ca_certificate.arn
  mitmproxy_ca_private_key_secret = data.aws_secretsmanager_secret.ca_private_key.arn
  vpc_id                          = module.private_tcp_active_active.network_id

}

module "private_tcp_active_active" {
  source = "../../"

  acm_certificate_arn   = var.acm_certificate_arn
  domain_name           = var.domain_name
  friendly_name_prefix  = local.friendly_name_prefix
  tfe_license_secret_id = try(module.secrets[0].tfe_license_secret_id, var.tfe_license_secret_id)

  ami_id                      = data.aws_ami.rhel.id
  ca_certificate_secret_id    = data.aws_secretsmanager_secret.ca_certificate.arn
  consolidated_services       = var.consolidated_services
  distribution                = "rhel"
  iact_subnet_list            = ["0.0.0.0/0"]
  iam_role_policy_arns        = [local.ssm_policy_arn, "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
  instance_type               = "m5.8xlarge"
  kms_key_arn                 = module.kms.key
  load_balancing_scheme       = local.load_balancing_scheme
  node_count                  = 2
  proxy_ip                    = module.test_proxy.proxy_ip
  proxy_port                  = local.http_proxy_port
  redis_encryption_at_rest    = true
  redis_encryption_in_transit = true
  redis_use_password_auth     = true
  tfe_subdomain               = local.test_name
  tls_bootstrap_cert_pathname = "/var/lib/terraform-enterprise/certificate.pem"
  tls_bootstrap_key_pathname  = "/var/lib/terraform-enterprise/key.pem"
  vm_certificate_secret_id    = var.certificate_pem_secret_id
  vm_key_secret_id            = var.private_key_pem_secret_id

  asg_tags = local.common_tags

  # FDO Specific Values
  is_legacy_deployment      = var.is_legacy_deployment
  hc_license                = var.hc_license
  license_reporting_opt_out = true
  registry_password         = var.registry_password
  registry_username         = var.registry_username
  tfe_image                 = "quay.io/hashicorp/terraform-enterprise:${var.tfe_image_tag}"
  tls_ca_bundle_file        = "/usr/share/pki/ca-trust-source/anchors/tfe-ca-certificate.crt"
}
