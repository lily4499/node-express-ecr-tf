provider "aws" {
  region = "us-east-1"  # Change to your desired region
}

# Define variables
variable "repository_name" {
  description = "Name of the ECR repository"
  default     = "node-express-app"  # Change with your repository name
}

# Create the ECR repository
resource "aws_ecr_repository" "lil_ecr_repository" {
  name = var.repository_name
  
}

