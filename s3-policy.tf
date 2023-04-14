provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "s3-bucket-policy-testing-fjfdgumesf"
}

resource "aws_s3_bucket_acl" "test_acl" {
  bucket = aws_s3_bucket.my_bucket.id
  acl    = "private"
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::ACCOUNT_ID:user/USERNAME"]
    }
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::my-bucket-name/*"]
  }
}

resource "aws_s3_bucket_policy" "my_bucket_policy" {
  bucket = aws_s3_bucket.my_bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}