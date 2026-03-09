pipeline {
    agent any
    environment {
        DOCKER_HUB_USER = "naeem3295"
        IMAGE_NAME = "jenkins-cicd-app"
        IMAGE_TAG = "v${BUILD_NUMBER}"
    }
    stages {
        stage('Checkout') {
            steps {
                echo "Checking out code..."
            }
        }
        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} ."
                sh "docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest ."
            }
        }
      stage('Test Image') {
    steps {
        echo "Image test করছি..."
        sh "docker run --rm ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} echo 'Container OK!'"
        echo "Test সফল!"
    }
}
        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
                    sh "docker logout"
                }
            }
        }
        stage('Deploy') {
            steps {
                sh "docker stop myapp 2>/dev/null || true"
                sh "docker rm myapp 2>/dev/null || true"
                sh "docker run -d --name myapp -p 8888:80 ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
                echo "App running at http://localhost:8888"
            }
        }
    }
    post {
        always {
            sh "docker stop test-${BUILD_NUMBER} 2>/dev/null || true"
            sh "docker rm test-${BUILD_NUMBER} 2>/dev/null || true"
        }
        success {
            echo "Pipeline SUCCESS!"
        }
        failure {
            echo "Pipeline FAILED!"
        }
    }
}
