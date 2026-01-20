resource "aws_s3_bucket" "artifacts" {
  bucket = "${var.project}-${var.environment}-artifacts"

  lifecycle_rule {
    id      = "auto-delete"
    enabled = true

    expiration {
      days = 7
    }
  }

  tags = {
    Name = "${var.project}-${var.environment}-artifacts"
  }
}

# LocalStack compatibility: ensure force path style is enabled in provider
