output "s3_artifact_bucket_name" {
  value = aws_s3_bucket.s3_artifact_bucket.id
  description = "name of the s3 artifact bucket"
}

output "s3_artifact_role_arn" {
  value = aws_iam_role.s3_artifact_role.arn
  description = "arn of the role for accessing s3 artifact"
}

output "aws_iam_instance_profile_name" {
  value = aws_iam_instance_profile.s3_artifact_instance_profile.name
  description = "The name of the IAM instance profile associated with the S3 artifact role."
}