resource "aws_iam_policy" "s3_access" {
  name        = "auth_s3_access"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:*"
        ],
        "Resource" : "arn:aws:s3:::*"
      }
    ]
  })
}

resource "aws_iam_policy" "dynamodb_access_policy_organisations" {
  name = "auth_lambda_access_dynamodb_policy_organisations"
  path = "/"

  policy = templatefile("templates/dynamo_access_policy.json", { table = "organisations" })
}