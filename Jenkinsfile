pipeline {
    agent any

    tools {
        terraform 'terraform_new'
    }

    
    stages {
        stage('Terraform init'){
            steps {
                sh "ls -la"
                //#sh '''terraform init'''

            }
        }



        stage('Build') {
            steps {
                echo 'Building PostgreSQL AWS RDS'
                sh "pwd"
                sh "cd terraform"
                sh "ls -la"
                
            }
        }
    }
}

