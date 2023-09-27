pipeline {
    agent any

    tools {
        terraform 'terraform_new'
    }

    
    stages {
        stage('Terraform init'){
            steps {
                echo "In this stage we initializate Terraform"
                sh '''cd terraform && terraform init && terraform plan'''

            }
        }



        stage('Build') {
            steps {
                echo 'Building PostgreSQL AWS RDS'
                sh "pwd && ls -la"
                sh '''cd terraform && terraform apply --auto-approve'''
                sleep 60
                
            }
        }
    stage('Connect DB') {
            steps {
                echo 'Connecting DB to RDS'
                sh "pwd && ls -la"
                sh "cd terraform && PGPASSWORD=demodemo psql -h $(terraform output -raw rds_hostname) -p $(terraform output -raw rds_port) -U $(terraform output -raw rds_username) MusicDB -f /var/lib/jenkins/workspace/DB/music_collection.sql"
                
                
            }
        }
    }
}

