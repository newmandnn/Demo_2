pipeline {
    agent any

    tools {
        terraform 'terraform_new'
    }

    
    stages {
        stage('Terraform init'){
            steps {
                echo "In this stage we initializate Terraform"
                sh '''cd terraform && terraform init'''

            }
        }



        stage('Build') {
            steps {
                echo 'Building PostgreSQL AWS RDS'
                sh "pwd && ls -la"
                sh '''cd terraform && terraform apply --auto-approve'''
                
                
            }
        }
    }
}

