pipeline {
    agent any

    tools {
        terraform 'terraform_new'
    }

    
    stages {
        stage('Terraform init'){
            steps {
                sh "ls -la"
                sh '''cd terraform && terraform init'''

            }
        }



        stage('Build') {
            steps {
                echo 'Building PostgreSQL AWS RDS'
                sh "pwd"
                sh "cd terraform && ls -la"
                sh "ls -la"
                
            }
        }
    }
}

