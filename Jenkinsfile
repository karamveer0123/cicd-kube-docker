pipeline {
    agent any

    environment {
        // Define your Docker registry and Kubernetes configurations
        DOCKER_REGISTRY = 'https://hub.docker.com/'
        IMAGE_NAME = 'karamveer91/mynginx'
        IMAGE_TAG = 'v3'
        KUBE_CONFIG = '/path/to/your/kubeconfig'  // Path to your kubeconfig file in Jenkins workspace or environment variable
        KUBE_NAMESPACE = 'kvns'  // Kubernetes namespace to deploy to
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout your source code repository
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://hub.docker.com/', 'dockerhubcred') {
                        docker.image("${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}").push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Use kubectl to apply the Kubernetes deployment
                    sh "kubectl --kubeconfig=${KUBE_CONFIG} -n ${KUBE_NAMESPACE} apply -f k8s/deployment.yaml"
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment succeeded!'
        }
        failure {
            echo 'Deployment failed.'
        }
    }
}

