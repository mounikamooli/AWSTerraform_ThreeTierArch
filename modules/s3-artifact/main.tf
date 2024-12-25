###############################################################################################################################################
########################################################## S3 Artifact ########################################################################
###############################################################################################################################################

# Define s3 bucket for artifact storage 

resource "aws_s3_bucket" "s3_artifact_bucket" {
  bucket = var.s3_artifact_bucket
  force_destroy = true
}

# block public access 

resource "aws_s3_bucket_public_access_block" "s3_artifact_public_block" {
  bucket = var.s3_artifact_bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


###############################################################################################################################################
################################### IAM policy, role and instance profile for S3 Artifact #####################################################
###############################################################################################################################################

# IAM policy for s3 artifact access

resource "aws_iam_policy" "s3_artifact_policy" {
  name = "s3-artifact-access-policy"
  path = "/"
  description = "allow access to s3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid" : "S3ArtifactAllowAccess",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::*/*",
          "arn:aws:s3:::var.s3_artifact_bucket",
          "arn:aws:s3:::var.s3_artifact_bucket/*"
        ]
      },
    ]
  })
}


# IAM role for s3 artifact access

resource "aws_iam_role" "s3_artifact_role" {
  name = "s3_artifact_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}


# IAM role policy attachement

resource "aws_iam_role_policy_attachment" "s3_artifact_role_policy_attachement" {
  role       = aws_iam_role.s3_artifact_role.name
  policy_arn = aws_iam_policy.s3_artifact_policy.arn
}


# IAM instance profile

resource "aws_iam_instance_profile" "s3_artifact_instance_profile" {
  name = "s3_artifact_instance_profile"
  role = aws_iam_role.s3_artifact_role.name
}
