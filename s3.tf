resource "aws_s3_bucket" "wordpress_s3" {
    bucket = var.bucket_name
    force_destroy = true
    tags = {
        Name = "terraform_s3"
    }
}

resource "aws_s3_bucket_public_access_block" "s3_public_access" {
  bucket = aws_s3_bucket.wordpress_s3.id

  ignore_public_acls      = false
  restrict_public_buckets = false
  block_public_acls       = false
  block_public_policy     = false
}

resource "aws_s3_bucket_ownership_controls" "s3_ownership" {
  bucket = aws_s3_bucket.wordpress_s3.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "s3_acl" {
  bucket = aws_s3_bucket.wordpress_s3.id
  acl    = "public-read"

  depends_on = [
    aws_s3_bucket_ownership_controls.s3_ownership,
    aws_s3_bucket_public_access_block.s3_public_access,
  ]
}

resource "aws_iam_user" "wordpress_s3_user" {
  name = "wordpress_s3_user"
}

resource "aws_iam_access_key" "wordpress_access_key" {
  user = aws_iam_user.wordpress_s3_user.name
}

resource "aws_iam_user_policy_attachment" "wordpress_s3_user_policy" {
  user       = aws_iam_user.wordpress_s3_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}