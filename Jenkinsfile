pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "karamveer91/mynginx:v${BUILD_NUMBER}"
        DOCKER_CREDENTIALS_ID = 'dockerhubcred' // Replace with your Docker credentials ID
        //KUBECONFIG = credentials('kubeconfig') // Optional, if you need to set up Kubernetes credentials
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker Image'
                    sh "docker build -t ${DOCKER_IMAGE} --no-cache ."
                    echo 'Build image done'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    echo 'Pushing Image to Docker Hub'
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh """
                            echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin
                            docker push ${DOCKER_IMAGE}
                        """
                    }
                }
            }
        }

        stage('Clean Up Docker Images') {
            steps {
                script {
                    echo 'Delete the docker image from workspace'
                    //sh 'docker rmi -f $(docker images -aq)'
                }
            }
        }
        stage('update kubernetes manifest') {
            steps {
                script {
                    echo 'Update kubernetes mainifest with latest docker Image'
                    sh """
                        sed -i 's#DOCKER_IMAGE#${DOCKER_IMAGE}#g' nginx-deployment.yaml
                       """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            agent {label 'test'}
              steps {
                script {
                    echo 'Create manifest in Kubernetes'
                    sh 'sed -i '
                    sh 'kubectl create -f nginx-deployment.yaml'
                }
            }
        }

        stage('Check Kubernetes Status') {
            agent {label 'test'}
              steps {
                script {
                    echo 'Print the status of the Kubernetes objects'
                    sh 'kubectl get all -n kvns'
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            // Any cleanup steps go here
        }

        success {
            echo 'Pipeline completed successfully.'
        }

        failure {
            echo 'Pipeline failed.'
        }
    }
}
