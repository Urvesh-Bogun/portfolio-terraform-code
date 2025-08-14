data "archive_file" "package_lambda_function_code" {
  type        = "zip"
  source_file = "${path.module}/lambda/inc_views.py"
  output_path = "${path.module}/lambda/packedlambda.zip"
}

resource "aws_lambda_function" "inc_views_func" {
  filename         = data.archive_file.package_lambda_function_code.output_path
  function_name    = "inc-portfolio-views-func"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "inc_views.lambda_handler"
  source_code_hash = data.archive_file.package_lambda_function_code.output_base64sha256

  runtime          = "python3.11"
}

resource "aws_lambda_function_url" "inc_views_func_url" {
  function_name      = aws_lambda_function.inc_views_func.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["https://www.urveshbogun.com", "https://urveshbogun.com", "http://localhost:3000"]
    allow_methods     = ["GET"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}