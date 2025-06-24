provider "aws" {
  region = local.region
}

locals {
  region      = "eu-north-1"
  name        = "secrets_manager"
  environment = "test"
}

module "secrets_manager" {

  source      = "../../"
  name        = local.name
  environment = local.environment

  secrets = [
    {
      name          = "secret-binary-1"
      description   = "This is a binary secret"
      secret_binary = "ssh-rsa /+ZHJ4gx0gB8yQ/yQtLXTuBh2FbtG9 test-ssh-key"
    },
    {
      name                    = "secret-binary-2"
      description             = "Another binary secret"
      secret_binary           = "ssh-rsa /+ZHJ4gx0gB8yQ/kJ//+BqIu9Paq/+5uUTxw9Qih+ test-ssh-key-2"
      recovery_window_in_days = 7
    }
  ]
}
