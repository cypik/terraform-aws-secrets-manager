locals {
  secrets = [
    for secret in var.secrets : {
      name                    = lookup(secret, "name", null)
      name_prefix             = lookup(secret, "name_prefix", null)
      description             = lookup(secret, "description", null)
      kms_key_id              = lookup(secret, "kms_key_id", null)
      policy                  = lookup(secret, "policy", null)
      replica                 = lookup(secret, "replica", null)
      recovery_window_in_days = lookup(secret, "recovery_window_in_days", var.recovery_window_in_days)
      secret_string = lookup(secret, "secret_string", null) != null ? lookup(secret, "secret_string", null) : (
        lookup(secret, "secret_key_value", null) != null ? jsonencode(lookup(secret, "secret_key_value", {})) : null
      )
      secret_binary = lookup(secret, "secret_string", null) == null ? lookup(secret, "secret_binary", null) : null
      tags          = lookup(secret, "tags", {})
    }
  ]
}

module "labels" {
  source  = "cypik/labels/aws"
  version = "1.0.2"

  name        = var.name
  environment = var.environment
  attributes  = var.attributes
  repository  = var.repository
  managedby   = var.managedby
  label_order = var.label_order
}

resource "aws_secretsmanager_secret" "main" {
  count                   = var.enabled ? length(local.secrets) : 0
  name                    = lookup(element(local.secrets, count.index), "name", null)
  name_prefix             = lookup(element(local.secrets, count.index), "name_prefix", null)
  description             = lookup(element(local.secrets, count.index), "description", null)
  kms_key_id              = lookup(element(local.secrets, count.index), "kms_key_id", null)
  policy                  = lookup(element(local.secrets, count.index), "policy", null)
  recovery_window_in_days = lookup(element(local.secrets, count.index), "recovery_window_in_days", null)

  dynamic "replica" {
    for_each = var.replica
    content {
      kms_key_id = lookup(replica.value, "kms_key_id", null)
      region     = lookup(replica.value, "region", null)
    }
  }

  tags = module.labels.tags
}

resource "aws_secretsmanager_secret_version" "sm-sv" {
  count         = var.unmanaged && var.enabled ? 0 : length(local.secrets)
  secret_id     = aws_secretsmanager_secret.main[0].id
  secret_string = lookup(element(local.secrets, count.index), "secret_string", null)
  secret_binary = lookup(element(local.secrets, count.index), "secret_binary", null) != null ? base64encode(lookup(element(local.secrets, count.index), "secret_binary", null)) : null
  depends_on    = [aws_secretsmanager_secret.main]
}

resource "aws_secretsmanager_secret_version" "sm-svu" {
  count         = var.unmanaged && var.enabled ? length(local.secrets) : 0
  secret_id     = aws_secretsmanager_secret.main[*].id[count.index]
  secret_string = lookup(element(local.secrets, count.index), "secret_string", null)
  secret_binary = lookup(element(local.secrets, count.index), "secret_binary", null) != null ? base64encode(lookup(element(local.secrets, count.index), "secret_binary", null)) : null
  depends_on    = [aws_secretsmanager_secret.main]

  lifecycle {
    ignore_changes = [
      secret_string,
      secret_binary,
      version_stages,
    ]
  }
}

resource "aws_secretsmanager_secret_rotation" "main" {
  count               = var.enabled && var.enable_rotation ? 1 : 0
  rotation_lambda_arn = var.rotation_lambda_arn
  secret_id           = aws_secretsmanager_secret.main[*].id

  dynamic "rotation_rules" {
    for_each = [var.rotation_rules]
    content {
      automatically_after_days = lookup(rotation_rules.value, "automatically_after_days", null)
      duration                 = lookup(rotation_rules.value, "duration", null)
      schedule_expression      = lookup(rotation_rules.value, "schedule_expression", null)
    }
  }

  depends_on = [aws_secretsmanager_secret.main]
}
