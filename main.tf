provider "aws" {
  region = "us-east-1"  # Change to your desired region
}

# Create the ECR repository
resource "aws_ecr_repository" "lil_repository" {
  name = "lili-ecr-repository"
  # Additional repository configurations can be added here if needed
}


