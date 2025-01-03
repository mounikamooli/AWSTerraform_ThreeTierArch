###############################################################################################################################################
######################################### S3 remote backend and Dynamodb state lock  ##########################################################
###############################################################################################################################################

# create an s3 bucket for remote backend

/*resource "aws_s3_bucket" "threetierremotebackend" {
  bucket = "threetierremotebackend"
}

# block public access for the bucket

resource "aws_s3_bucket_public_access_block" "threetier_remotebackend_block_public" {
  bucket = aws_s3_bucket.threetierremotebackend.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# enable versioning for the bucket

resource "aws_s3_bucket_versioning" "threetier_remotebackend_versioning" {
  bucket = aws_s3_bucket.threetierremotebackend.id
  versioning_configuration {
    status = "Enabled"
  }
}

# enable server side encryption for the bucket

resource "aws_s3_bucket_server_side_encryption_configuration" "threetier_remotebackend_encryption" {
  bucket = aws_s3_bucket.threetierremotebackend.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# restrict s3 remote backend bucket to specific user

resource "aws_s3_bucket_policy" "threetier_remotebackend_bucket_policy" {
  bucket = aws_s3_bucket.threetierremotebackend.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          AWS = "arn:aws:iam::120569621791:user/terrafom-admin"
        }
        Action    = [
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject"
        ]
        Resource  = [
          "arn:aws:s3:::threetierremotebackend",
          "arn:aws:s3:::threetierremotebackend/terraform.tfstate"
        ]
      },
      {
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:DeleteBucket"
        Resource  = "arn:aws:s3:::threetierremotebackend"
      }
    ]
  })
}

# define dynamodb for state locking

resource "aws_dynamodb_table" "remotebackend_statelock_dynamodb" {
  name = "remotebackend_statelock_dynamodb"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# IAM Policy for DynamoDB State Locking

resource "aws_iam_policy" "terraform_dynamodb_state_lock_policy" {
  name        = "terraform-dynamodb-state-lock-policy"
  description = "Allows Terraform to manage DynamoDB state locking operations"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ]
        Resource = "arn:aws:dynamodb:us-east-1:120569621791:table/remotebackend_statelock_dynamodb"
      }
    ]
  })
}*/


