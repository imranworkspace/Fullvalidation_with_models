pipeline {
    agent any   // Run this pipeline on any available Jenkins agent

    environment {
        // Define environment variables used throughout the pipeline
        VENV = "myenv"   // Name of the Python virtual environment
        PYTHON = "C:\\Users\\imran\\AppData\\Local\\Programs\\Python\\Python38\\python.exe"   // Path to the Python executable (adjust if needed)
        DOCKER_IMAGE = "imrandocker24/formvalidation_with__model"   // Docker image name to build and push
    }

    stages {

        stage('Checkout Code') {
            steps {
                // Clone the source code from the GitHub repository
                git branch: 'main', url: 'https://github.com/imranworkspace/Fullvalidation_with_models'
            }
        }

        stage('Setup Virtualenv') {
            steps {
                // Create a new Python virtual environment
                bat "%PYTHON% -m venv %VENV%"
                // Upgrade pip to the latest version
                bat "%VENV%\\Scripts\\python -m pip install --upgrade pip"
                // Install dependencies from requirements.txt
                bat "%VENV%\\Scripts\\pip install -r requirements.txt"
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    bat """
                        echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin
                    """
                }
            }
        }

        stage('Run Migrations') {
            steps {
                // Create and apply database migrations
                // bat "%VENV%\\Scripts\\python manage.py makemigrations"
                // bat "%VENV%\\Scripts\\python manage.py migrate"
                bat 'docker-compose run django python manage.py makemigrations'
                bat 'docker-compose run django python manage.py migrate'
            }
        }
        stage('Build Docker Image') {
            steps {
                // Build the Docker image from the Dockerfile in the repository
                bat "docker build -t %DOCKER_IMAGE% ."
            }
        }
        
    }
}
