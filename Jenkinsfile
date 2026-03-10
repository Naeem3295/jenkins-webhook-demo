pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = "naeem3295"
        IMAGE_NAME      = "jenkins-cicd-app"
        IMAGE_TAG       = "v${BUILD_NUMBER}"
        EMAIL_TO        = "abunaeem059322@gmail.com"
        SLACK_CHANNEL   = "#general"
    }

    stages {

        stage('Checkout') {
            steps {
                echo "GitHub থেকে code নামাচ্ছি..."
                slackSend(
                    channel: "${SLACK_CHANNEL}",
                    color: '#FFFF00',
                    message: "🔄 Build #${BUILD_NUMBER} শুরু হয়েছে!\nJob: ${JOB_NAME}"
                )
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Docker Image build করছি..."
                sh "docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} ."
                sh "docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest ."
                echo "Build সম্পন্ন!"
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
            }
        }

        stage('Deploy') {
            steps {
                sh "docker stop myapp 2>/dev/null || true"
                sh "docker rm myapp 2>/dev/null || true"
                sh "docker run -d --name myapp -p 8888:80 ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
                echo "App: http://localhost:8888"
            }
        }
    }

    post {
        always {
            sh "docker stop test-${BUILD_NUMBER} 2>/dev/null || true"
            sh "docker rm test-${BUILD_NUMBER} 2>/dev/null || true"
        }

        success {
            echo "✅ Pipeline সফল!"
            slackSend(
                channel: "${SLACK_CHANNEL}",
                color: 'good',
                message: """✅ Build SUCCESS!
Job: ${JOB_NAME}
Build: #${BUILD_NUMBER}
Duration: ${currentBuild.durationString}
URL: ${BUILD_URL}"""
            )
            emailext(
                to: "${EMAIL_TO}",
                subject: "✅ SUCCESS: ${JOB_NAME} #${BUILD_NUMBER}",
                body: "<h2 style='color:green'>Build Successful!</h2><p>Build: #${BUILD_NUMBER}</p><p><a href='${BUILD_URL}'>Details</a></p>",
                mimeType: 'text/html'
            )
        }

        failure {
            echo "❌ Pipeline ব্যর্থ!"
            slackSend(
                channel: "${SLACK_CHANNEL}",
                color: 'danger',
                message: """❌ Build FAILED!
Job: ${JOB_NAME}
Build: #${BUILD_NUMBER}
URL: ${BUILD_URL}console"""
            )
            emailext(
                to: "${EMAIL_TO}",
                subject: "❌ FAILED: ${JOB_NAME} #${BUILD_NUMBER}",
                body: "<h2 style='color:red'>Build Failed!</h2><p>Build: #${BUILD_NUMBER}</p><p><a href='${BUILD_URL}console'>Error দেখো</a></p>",
                mimeType: 'text/html'
            )
        }
    }
}
```
```
Commit message: "Add Slack Notification"
→ Commit changes
```

---

# 📌 STEP 7 — Test করো!

### Jenkins এ Build করো:
```
localhost:9090 →
github-webhook-pipeline →
Build Now
```

### Slack এ দেখো:
```
Slack → jenkins-cicd workspace →
#general channel
↓
এরকম message আসবে:

🔄 Build #12 শুরু হয়েছে!
Job: github-webhook-pipeline

তারপর:

✅ Build SUCCESS!
Job: github-webhook-pipeline
Build: #12
Duration: 45 sec
URL: http://localhost:9090/...
```

---

## ✅ Part 7 Checklist:
```
☐ Slack account বানিয়েছি
☐ Workspace তৈরি করেছি
☐ Slack App বানিয়েছি
☐ Incoming Webhook enable করেছি
☐ Webhook URL পেয়েছি
☐ Jenkins এ Slack Plugin install করেছি
☐ Jenkins এ Slack configure করেছি
☐ Test Connection সফল হয়েছে
☐ Jenkinsfile এ Slack যোগ করেছি
☐ Slack এ message আসছে
