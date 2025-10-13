pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "imrandocker24/formvalidation_with__model-web:latest"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/imranworkspace/Fullvalidation_with_models'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat "docker build -t %DOCKER_IMAGE% ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    bat """
                        echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin
                        docker push %DOCKER_IMAGE%
                    """
                }
            }
        }

        stage('Run Containers') {
            steps {
                bat "docker-compose -f docker-compose.yml up -d --force-recreate"
            }
        }
    }
}