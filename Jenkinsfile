pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                echo "Code checkout from GitHub!"
            }
        }

        stage('Build') {
            steps {
                echo "Building application..."
                sh 'echo "Build started"'
            }
        }

        stage('Test') {
            steps {
                echo "Running tests..."
                sh 'echo "All tests passed!"'
            }
        }

        stage('Done') {
            steps {
                echo "Pipeline complete!"
            }
        }
    }

    post {
        success {
            echo "✅ Build SUCCESS - Triggered by GitHub!"
        }
        failure {
            echo "❌ Build FAILED!"
        }
    }
}
