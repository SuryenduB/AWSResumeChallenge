resource "aws_s3_bucket" "sury-resume-bucket" {
  bucket = "sury-resume-bucket"

}





resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.sury-resume-bucket.id


  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

data "aws_iam_policy_document" "allow_read_access_from_all_account" {
  statement {
    sid    = "PublicReadGetObject"
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]


    resources = [
      aws_s3_bucket.sury-resume-bucket.arn,
      "${aws_s3_bucket.sury-resume-bucket.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "allow_read_access_from_all_account" {
  bucket     = aws_s3_bucket.sury-resume-bucket.id
  policy     = data.aws_iam_policy_document.allow_read_access_from_all_account.json
  depends_on = [aws_s3_bucket_public_access_block.example]

}


resource "aws_s3_bucket_website_configuration" "example" {
  bucket     = aws_s3_bucket.sury-resume-bucket.id
  depends_on = [aws_s3_object.object]

  index_document {
    suffix = "index.html"
  }


}

resource "aws_s3_object" "object" {
  bucket       = "sury-resume-bucket"
  key          = "index.html"
  source       = "../index.html"
  content_type = "text/html"

  depends_on = [
    aws_s3_bucket.sury-resume-bucket,

    aws_s3_bucket_public_access_block.example
  ]
  etag = filemd5("../index.html")
}

resource "aws_s3_object" "test" {
  for_each = fileset("../images", "*.*")

  bucket = aws_s3_bucket.sury-resume-bucket.id
  key    = "images/${each.value}"
  source = "../images/${each.value}"
}


resource "aws_s3_bucket_cors_configuration" "allow_core" {
  bucket = aws_s3_bucket.sury-resume-bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["POST", "GET"]
    allowed_origins = ["*"]

  }
  depends_on = [aws_s3_bucket.sury-resume-bucket]


}