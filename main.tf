provider "aws" {
  region = "us-east-1"  # Change to your desired region
}

# Create the ECR repository
resource "aws_ecr_repository" "lil_repository" {
  name = "node-express-app"
  # Additional repository configurations can be added here if needed
}


