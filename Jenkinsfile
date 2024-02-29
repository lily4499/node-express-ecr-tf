pipeline {
    agent any

    parameters {
        choice(name: 'TERRAFORM_ACTION', choices: ['apply', 'destroy'], description: 'Select Terraform action to perform')
    }
    
    environment {
        AWS_ACCESS_KEY_ID  = credentials('lil_AWS_Access_key_ID')
        AWS_SECRET_ACCESS_KEY = credentials('lil_AWS_Secret_access_key')
        AWS_REGION = 'us-east-1'
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
                        echo 'Terraform destroy chosen. Halting pipeline.'
                        currentBuild.result = 'ABORTED'
                        error 'Terraform destroy chosen. Halting pipeline.'
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
