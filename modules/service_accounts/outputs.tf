# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "iam_instance_profile" {
  value = local.iam_instance_profile

  description = "The IAM instance profile to be attached to the TFE EC2 instance(s)."
}

output "iam_role" {
  value = local.iam_instance_role

  description = "The IAM role associated with the instance profile."
}
