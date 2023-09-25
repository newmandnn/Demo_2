pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building PostgreSQL AWS RDS'
                sh "pwd"
                sh "cd terraform"
                terraform plan
            }
        }
    }
}