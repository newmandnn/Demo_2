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

        stage('Terraform build ECR'){
            steps {
                echo "In this stage we initializate ECR"
                sh '''cd terraform && terraform apply --auto-approve -target=module.ecr'''

            }
        }

        stage('Build/Push Docker image to ECR'){
            steps {
                echo "In this stage we build Docker image and push it to ECR"
                sh  "aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 877879097973.dkr.ecr.eu-central-1.amazonaws.com" 
                sh  "docker build -t demo_2_app Flask_Docker/." 
                sh  "docker tag demo_2_app:latest 877879097973.dkr.ecr.eu-central-1.amazonaws.com/demo_2_app:latest" 
                sh  "docker push 877879097973.dkr.ecr.eu-central-1.amazonaws.com/demo_2_app:latest" 
            }
        }

        stage('Build RDS/ECS and all other tools in AWS') {
            steps {
                echo 'Building PostgreSQL AWS RDS and ECS-cluster with app'
                sh "pwd && ls -la"
                sh '''cd terraform && terraform apply --auto-approve'''
                sleep 60
                
            }
        }
        
        stage('Connect my DataBase to DB instance ') {
            steps {
                echo 'Connecting DB to RDS'
                sh "pwd && ls -la"
                sh '''cd terraform && PGPASSWORD=$(aws secretsmanager get-secret-value --secret-id key_rds --version-stage AWSCURRENT | jq --raw-output .SecretString | jq -r ."password") psql -h $(terraform output -raw rds_hostname) -p $(terraform output -raw rds_port) -U $(terraform output -raw rds_username) MusicDB -f /var/lib/jenkins/workspace/DB/music_collection.sql'''
                
                
            }
        }
    }
}

