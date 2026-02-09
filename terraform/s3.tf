resource "aws_s3_bucket" "artifacts" {
  bucket = "${var.project}-${var.environment}-artifacts"

  tags = {
    Name = "${var.project}-${var.environment}-artifacts"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "artifacts" {
    bucket = aws_s3_bucket.artifacts.id
    rule {
        id      = "auto-delete"
        status = "Enabled"
        expiration {
        days = 7
    }
  }
}
# LocalStack compatibility: ensure force path style is enabled in provider
