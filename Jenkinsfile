pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = "তোমার-dockerhub-username"
        IMAGE_NAME      = "jenkins-cicd-app"
        IMAGE_TAG       = "v${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                echo "================================"
                echo "GitHub থেকে code নামাচ্ছি..."
                echo "Build Number: ${BUILD_NUMBER}"
                echo "================================"
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
                echo "✅ Test সফল! Web app চলছে!"
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo "Docker Hub এ push করছি..."
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'naeem3295',
                    passwordVariable: Naeem3295
                )]) {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
                    sh "docker logout"
                }
                echo "✅ Docker Hub এ push সম্পন্ন!"
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploy করছি..."
                sh "docker stop myapp 2>/dev/null || true"
                sh "docker rm myapp 2>/dev/null || true"
                sh "docker run -d --name myapp -p 8888:80 ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
                echo "✅ App চালু হয়েছে!"
                echo "দেখো: http://localhost:8888"
            }
        }
    }

    post {
        always {
            echo "Cleanup করছি..."
            sh "docker stop test-${BUILD_NUMBER} 2>/dev/null || true"
            sh "docker rm test-${BUILD_NUMBER} 2>/dev/null || true"
        }
        success {
            echo "================================"
            echo "✅ CI/CD Pipeline সফল!"
            echo "App: http://localhost:8888"
            echo "================================"
        }
        failure {
            echo "================================"
            echo "❌ Pipeline ব্যর্থ!"
            echo "Console Output চেক করো"
            echo "================================"
        }
    }
}
```

### ⚠️ এই line টা পরিবর্তন করো:
```
DOCKER_HUB_USER = "তোমার-dockerhub-username"
↓
যেমন তোমার username যদি naeem3295 হয়:
DOCKER_HUB_USER = "naeem3295"
```
```
Commit message: "Update Jenkinsfile for Docker CI/CD"
→ Commit changes
```

---

# 📚 STEP 3 — Jenkins এ Docker Hub Credentials যোগ করো

### কেন লাগবে:
```
Docker Hub এ push করতে
username + password লাগে

Jenkinsfile এ সরাসরি লেখা যাবে না!
কারণ:
→ GitHub এ সবাই দেখতে পাবে
→ Security risk!

তাই Jenkins এ secure ভাবে রাখবো
Jenkinsfile শুধু ID দিয়ে access করবে
```

### কোথায় যাবো:
```
localhost:9090 →
Manage Jenkins →
Credentials →
System →
Global credentials (unrestricted) →
"Add Credentials" button
```

### কী দেবো:
```
Kind: 
Username with password ✅ select করো
↓
এই type এ username আর 
password আলাদা রাখা যায়

Scope: 
Global ✅
↓
সব job এ ব্যবহার করা যাবে

Username: 
তোমার Docker Hub username
যেমন: naeem3295

Password: 
তোমার Docker Hub password

ID: 
dockerhub-credentials
↓
⚠️ এটা ঠিক এভাবেই লিখতে হবে!
Jenkinsfile এ এই ID ব্যবহার করেছি

Description: 
Docker Hub Login Credentials

→ "Create" button click করো
```

### Credentials সফলভাবে যোগ হলে:
```
Global credentials list এ দেখাবে:
dockerhub-credentials
Username: naeem3295
✅
```

---

# 📚 STEP 4 — Jenkins এ Docker Permission দাও

### কেন লাগবে:
```
Jenkins Docker container এর ভেতরে চলে
Docker command run করতে হলে
permission লাগে!

না দিলে error আসবে:
"permission denied while trying to 
connect to Docker daemon"
```

### কোথায় যাবো:
```
CMD/Terminal খোলো
(Docker Desktop চালু থাকতে হবে)
