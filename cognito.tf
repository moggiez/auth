resource "aws_cognito_user_pool" "_" {
  name = var.domain_name

  username_attributes = ["email"]

  auto_verified_attributes = ["email"]

  username_configuration {
    case_sensitive = false
  }

  email_configuration {
    configuration_set     = "moggies"
    email_sending_account = "DEVELOPER"
    from_email_address    = "${var.domain_name} <noreply@moggies.io>"
    source_arn            = "arn:aws:ses:${var.region}:${var.account}:identity/noreply@${var.domain_name}"
  }

  // This is only used if the customMessage trigger is disabled
  verification_message_template {
    default_email_option  = "CONFIRM_WITH_CODE"
    email_message = "Please confirm with your code {####}."
    email_subject = "Your ${var.domain_name} account verification link"
  }

  lambda_config {
    custom_message = aws_lambda_function.custom_message.arn
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }
}

resource "aws_cognito_user_pool_client" "_" {
  name = "webui_client"

  user_pool_id    = aws_cognito_user_pool._.id
  generate_secret = false

  callback_urls = ["https://moggies.io/dashboard"]
}

resource "aws_cognito_user_pool_domain" "_" {
  domain          = "auth.${var.domain_name}"
  certificate_arn = aws_acm_certificate._.arn
  user_pool_id    = aws_cognito_user_pool._.id
}