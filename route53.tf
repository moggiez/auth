data "aws_route53_zone" "_" {
  name = var.domain_name
}

resource "aws_route53_record" "auth-cognito-A" {
  name    = aws_cognito_user_pool_domain._.domain
  type    = "A"
  zone_id = data.aws_route53_zone._.zone_id
  alias {
    evaluate_target_health = false
    name                   = aws_cognito_user_pool_domain._.cloudfront_distribution_arn
    # This zone_id is fixed
    zone_id = "Z2FDTNDATAQYW2"
  }
}