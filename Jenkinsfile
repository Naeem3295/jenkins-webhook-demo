pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = "naeem3295"
        IMAGE_NAME      = "jenkins-cicd-app"
        IMAGE_TAG       = "v${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                echo "GitHub থেকে code নামাচ্ছি..."
                echo "Build Number: ${BUILD_NUMBER}"
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Docker Image build করছি..."
                sh "docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} ."
                sh "docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest ."
                echo "Image build সম্পন্ন!"
            }
        }

        stage('Test Image') {
            steps {
                echo "Image test করছি..."
                sh "docker run -d --name test-${BUILD_NUMBER} -p 8090:80 ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
                sh "sleep 3"
                sh "curl -f http://localhost:8090"
                echo "Test সফল!"
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo "Docker Hub এ push করছি..."
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
                    sh "docker logout"
                }
                echo "Push সম্পন্ন!"
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploy করছি..."
                sh "docker stop myapp 2>/dev/null || true"
                sh "docker rm myapp 2>/dev/null || true"
                sh "docker run -d --name myapp -p 8888:80 ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
                echo "App চালু! http://localhost:8888"
            }
        }
    }

    post {
        always {
            sh "docker stop test-${BUILD_NUMBER} 2>/dev/null || true"
            sh "docker rm test-${BUILD_NUMBER} 2>/dev/null || true"
        }
        success {
            echo "✅ CI/CD Pipeline সফল!"
            echo "App: http://localhost:8888"
        }
        failure {
            echo "❌ Pipeline ব্যর্থ!"
        }
    }
}
```
```
Commit message: "Fix Jenkinsfile"
→ Commit changes
