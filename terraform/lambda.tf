data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "../build/index.js"
  output_path = "lambda_function.zip"
}

resource "aws_lambda_function" "sms_sender" {
  filename         = "lambda_function.zip"
  function_name    = "sms_sender"
  handler          = "index.handler"
  role             = aws_iam_role.iam_for_lambda_tf.arn
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "nodejs16.x"
}

resource "aws_lambda_event_source_mapping" "example" {
  event_source_arn = aws_sqs_queue.send_text_queue.arn
  function_name    = aws_lambda_function.sms_sender.arn
}
