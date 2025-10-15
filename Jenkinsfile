pipeline {
    agent any

    environment {
        VENV = "myenv"
        PYTHON = "C:\\Users\\imran\\AppData\\Local\\Programs\\Python\\Python38\\python.exe"   // <-- adjust if Python path is different
        DOCKER_IMAGE = "imrandocker24/formvalidation_with__model"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'master', url: 'https://github.com/imranworkspace/Fullvalidation_with_models'
            }
        }

        stage('Setup Virtualenv') {
            steps {
                bat "%PYTHON% -m venv %VENV%"
                bat "%VENV%\\Scripts\\python -m pip install --upgrade pip"
                bat "%VENV%\\Scripts\\pip install -r requirements.txt"
            }
        }

        stage('Run Migrations') {
            steps {
                bat "%VENV%\\Scripts\\python manage.py makemigrations"
                bat "%VENV%\\Scripts\\python manage.py migrate"
            }
        }

        stage('Run Tests') {
            steps {
                bat "%VENV%\\Scripts\\python manage.py test app.tests.test_views"
                bat "%VENV%\\Scripts\\python manage.py test app.tests.test_models"
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

        stage('Run Container') {
            steps {
                bat 'docker-compose -f docker-compose.yml up -d --force-recreate'
            }
        }

        // if docker and jenkins both are same machine then no need below one 
        // stage('Deploy to Server') {
        //     steps {
        //         withCredentials([sshUserPrivateKey(credentialsId: 'my-ssh-cred-key', keyFileVariable: 'SSH_KEY')]) {
        //             bat '''
        //                 ssh -i %SSH_KEY% -o StrictHostKeyChecking=no deploy@app.example.com ^
        //                 "docker pull imrandocker24/djredcledockerjenkins2:latest && ^
        //                 docker-compose -f /opt/app/docker-compose.yml up -d --force-recreate"
        //             '''
        //         }
        //     }
        // } 

    }


}