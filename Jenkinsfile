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
        BUILB_NUMBER = env.BUILD_NUMBER // Declaring the environment variable
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

        stage('Terraform Action') {
            steps {
                script {
                    if (params.TERRAFORM_ACTION == 'apply') {
                        sh 'terraform apply -auto-approve'
                    } else if (params.TERRAFORM_ACTION == 'destroy') {
                    //   sh 'aws ecr delete-repository --repository-name ${REPOSITORY_NAME} --force'
                    //   sh 'terraform destroy -auto-approve'
                       sh 'aws ecr batch-delete-image --repository-name ${REPOSITORY_NAME} --image-ids imageTag="${BUILB_NUMBER}" '


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
    
    post {
        always {
            script {
                if (params.TERRAFORM_ACTION == 'destroy') {
                    // Delete ECR repository
                    sh 'terraform destroy -auto-approve'
                    echo 'ECR repository deleted successfully.'
                }
            }
        }
    }
}
