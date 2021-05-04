resource "aws_cognito_user_pool" "_" {
  name = var.domain_name

  username_attributes = ["email"]

  username_configuration {
    case_sensitive = false
  }

  email_configuration {
    configuration_set     = "moggies"
    email_sending_account = "DEVELOPER"
    from_email_address    = "${var.domain_name} <noreply@moggies.io>"
    source_arn            = "arn:aws:ses:${var.region}:${var.account}:identity/noreply@${var.domain_name}"
  }

  verification_message_template {
    default_email_option  = "CONFIRM_WITH_LINK"
    email_message_by_link = "Please click the link below to verify your email address. {##Verify Email##}"
    email_subject_by_link = "Your ${var.domain_name} account verification link"
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
}

resource "aws_cognito_user_pool_domain" "_" {
  domain          = "auth.${var.domain_name}"
  certificate_arn = aws_acm_certificate._.arn
  user_pool_id    = aws_cognito_user_pool._.id
}