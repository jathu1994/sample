terraform {
  backend "s3" {
    bucket = "week4s3114518228"                // Bucket where to SAVE Terraform State
    key    = "01-networking/terraform.tfstate" // Object name in the bucket to SAVE Terraform State
    region = "us-east-1"                       // Region where bucket is created
  }
}