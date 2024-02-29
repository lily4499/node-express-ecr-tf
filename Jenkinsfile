pipeline {
    agent any

    parameters {
        choice(name: 'TERRAFORM_ACTION', choices: ['apply', 'destroy'], description: 'Select Terraform action to perform')
    }
    
    environment {
        AWS_ACCESS_KEY_ID  = credentials('lil_AWS_ECR_Access_key_ID')
        AWS_SECRET_ACCESS_KEY = credentials('lil_AWS_ECR_Secret_access_key')
        AWS_REGION = 'us-east-1'
        REPOSITORY_NAME = 'node-express-app'
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/lily4499/node-express-ecr-tf.git'
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }

        stage('List ECR Images') {
            steps {
                script {
                    // Get list of image tags from ECR and store as variable
                    def imageTags = sh(script: "aws ecr list-images --repository-name ${REPOSITORY_NAME} --region ${AWS_REGION} --output json | jq -r '.imageIds[].imageTag'", returnStdout: true).trim()
                    
                    // Display the image tags
                    echo "Images in repository ${REPOSITORY_NAME}:"
                    echo "$imageTags"
                    
                    // Store the image tags as an array variable
                    def imageTagsArray = imageTags.split("\n")
                    
                    // Use the first image tag for deletion
                    imageToDelete = imageTagsArray[0]
                    
                    // Print the image tag to be deleted
                    echo "Image to be deleted: $imageToDelete"
                }
            }
        }

        stage('Terraform Action') {
            steps {
                script {
                    if (params.TERRAFORM_ACTION == 'apply') {
                        sh 'terraform apply -auto-approve'
                    } else if (params.TERRAFORM_ACTION == 'destroy') {
                        // Delete the first image from the ECR repository
                        sh "aws ecr batch-delete-image --repository-name ${REPOSITORY_NAME} --image-ids imageTag='${imageToDelete}' --region ${AWS_REGION}"
                        sh 'terraform destroy -auto-approve'
                    } else {
                        error 'Invalid Terraform action specified!'
                    }
                }
            }
        }
        
        stage('Trigger Jenkins Job to Push Docker Image to ECR') {
            when {
                expression { params.TERRAFORM_ACTION == 'apply' }
            }
            steps {
                script {
                    // Trigger another Jenkins job to push Docker image to ECR
                    build job: 'push-node-express-app-ecr', wait: true
                }
            }
        }
    
    }
}
