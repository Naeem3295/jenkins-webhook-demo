Complete Jenkins CI/CD Pipeline with Slack & Email Notification
✅ Part 7: Slack & Email Notification Setup
Step 1: Create Slack Account & Workspace
text
1. Go to https://slack.com
2. Sign up / Login
3. Create Workspace: "Jenkins-CICD"
4. Create Channel: "#general" or "#jenkins-notifications"
Step 2: Create Slack App & Get Webhook URL
text
1. Go to https://api.slack.com/apps
2. Click "Create New App" → "From scratch"
3. App Name: "Jenkins Notifier"
4. Select your workspace
5. Click "Create App"

6. Go to "Incoming Webhooks" (left menu)
7. Toggle "Activate Incoming Webhooks" → ON
8. Click "Add New Webhook to Workspace"
9. Select Channel: "#general"
10. Click "Allow"
11. Copy the Webhook URL (starts with https://hooks.slack.com/services/...)
Step 3: Install Slack Plugin in Jenkins
text
Jenkins Dashboard → Manage Jenkins → Plugins → Available Plugins

Search: "Slack Notification"
☑ Slack Notification Plugin
☑ Blue Ocean (optional)

Click "Download now and install after restart"
Step 4: Configure Slack in Jenkins
text
Jenkins Dashboard → Manage Jenkins → System

Scroll to "Slack" Section:

Workspace: jenkins-cicd (your workspace name)
Credential: Add → Jenkins
  Domain: Global credentials
  Kind: Secret text
  Secret: YOUR_WEBHOOK_URL (from Step 2)
  ID: slack-webhook
  Description: Slack Notification

Default channel: #general
Click "Save"
Test Connection: Click "Test Connection" → Should say "Success"

Step 5: Email Configuration in Jenkins
text
Jenkins Dashboard → Manage Jenkins → System

Scroll to "E-mail Notification":

SMTP server: smtp.gmail.com
Use SSL: ☑
Port: 465

Advanced → Credentials: Add → Jenkins
  Username: your-email@gmail.com
  Password: your-app-password (Gmail App Password)
  ID: email-credentials

Test by sending test e-mail
Step 6: Complete Jenkinsfile (Ready to Use)
groovy
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
                echo "Cloning code from GitHub..."
                slackSend(
                    channel: "${SLACK_CHANNEL}",
                    color: '#FFFF00',
                    message: "🔄 Build #${BUILD_NUMBER} started!\nJob: ${JOB_NAME}"
                )
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh "docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} ."
                sh "docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest ."
                echo "Build complete!"
            }
        }

        stage('Test Image') {
            steps {
                echo "Testing image..."
                sh "docker run --rm ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} echo 'Container OK!'"
                echo "Test successful!"
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
                echo "App running at: http://localhost:8888"
            }
        }
    }

    post {
        always {
            sh "docker stop test-${BUILD_NUMBER} 2>/dev/null || true"
            sh "docker rm test-${BUILD_NUMBER} 2>/dev/null || true"
        }

        success {
            echo "✅ Pipeline successful!"
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
            echo "❌ Pipeline failed!"
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
                body: "<h2 style='color:red'>Build Failed!</h2><p>Build: #${BUILD_NUMBER}</p><p><a href='${BUILD_URL}console'>Check error</a></p>",
                mimeType: 'text/html'
            )
        }
    }
}
Step 7: Push to GitHub & Test
bash
# Add Jenkinsfile to your repository
git add Jenkinsfile
git commit -m "Add Slack & Email notifications to pipeline"
git push origin main
Step 8: Trigger Build in Jenkins
text
Jenkins Dashboard → Your Pipeline Job → Build Now
✅ Expected Results:
Slack Channel:
text
🔄 Build #12 started!
Job: github-webhook-pipeline

✅ Build SUCCESS!
Job: github-webhook-pipeline
Build: #12
Duration: 45 sec
URL: http://localhost:9090/...
Email:
text
Subject: ✅ SUCCESS: github-webhook-pipeline #12

Build Successful!
Build: #12
Details: http://localhost:9090/...
✅ Part 7 Checklist:
text
☐ Slack account created
☐ Workspace created (jenkins-cicd)
☐ Slack App created
☐ Incoming Webhook enabled
☐ Webhook URL obtained
☐ Slack Plugin installed in Jenkins
☐ Slack configured in Jenkins
☐ Test Connection successful
☐ Jenkinsfile updated with Slack
☐ Commit & Push to GitHub
☐ Slack messages received
