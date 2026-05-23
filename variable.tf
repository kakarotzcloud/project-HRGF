variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket to store Terraform state"
  type        = string
}
