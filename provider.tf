# Backend configuration for storing Terraform state in S3
/* terraform {
  backend "s3" {
    bucket         = "" # Replace with S3 bucket
    key            = "tfstate_file/terraform.tfstate"
    region         = "" # Replace with your desired region
    encrypt        = true
    dynamodb_table = "" # Replace with your dynamodb table name
  }
} */

provider "aws" {
  region = "" # Add the region where the resources must be deployed
}