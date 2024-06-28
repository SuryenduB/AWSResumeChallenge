data "archive_file" "lambda_package" {
  type        = "zip"
  source_file = "index.py"
  output_path = "index.zip"
}