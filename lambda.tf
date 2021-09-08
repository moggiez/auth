resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })

  managed_policy_arns = [
    aws_iam_policy.dynamodb_access_policy_organisations.arn,
    aws_iam_policy.s3_access.arn
  ]
}

resource "aws_lambda_function" "custom_message" {
  filename         = "./dist/custom_message.zip"
  function_name    = "cognito_trigger_custom_message"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "index.handler"
  source_code_hash = filebase64sha256("./dist/custom_message.zip")
  timeout          = 60
  runtime          = "nodejs14.x"
}

resource "aws_lambda_function" "post_confirmation" {
  filename         = "./dist/post_confirmation.zip"
  function_name    = "cognito_trigger_post_confirmation"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "index.handler"
  source_code_hash = filebase64sha256("./dist/post_confirmation.zip")
  timeout          = 60
  runtime          = "nodejs14.x"

  layers = []
}
