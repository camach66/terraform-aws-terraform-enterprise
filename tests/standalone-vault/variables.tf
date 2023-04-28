# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "acm_certificate_arn" {
  type        = string
  description = "The ARN of an existing ACM certificate."
}

variable "aws_role_arn" {
  type        = string
  description = "The AWS Role ARN to assume for this module."
}

variable "consolidated_services" {
  default     = false
  type        = bool
  description = "(Required) True if TFE uses consolidated services."
}

variable "domain_name" {
  type        = string
  description = "Domain for creating the Terraform Enterprise subdomain on."
}

variable "key_name" {
  default     = null
  description = "The name of the key pair to be used for SSH access to the EC2 instance(s)."
  type        = string
}

variable "license_file" {
  default     = null
  type        = string
  description = "The local path to the Terraform Enterprise license to be provided by CI."
}

variable "tfe_license_secret_id" {
  default     = null
  type        = string
  description = "The Secrets Manager secret ARN under which the Base64 encoded Terraform Enterprise license is stored."
}
