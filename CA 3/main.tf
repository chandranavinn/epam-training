terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# ConfigureAWS Provider
provider "aws" {
  region = var.region_name
}

variable "region_name" {
  default     = "us-east-1"
}

variable "bucket_prefix" {
  default     = "tfbucketnavin"

}


# CREATING BUCKET
resource "aws_s3_bucket" "bucket" {
 
  bucket_prefix = var.bucket_prefix


  tags = {
    Name = "tfbucket"
  }
}


output "bucket_id" {
  value = resource.aws_s3_bucket.bucket.id
}