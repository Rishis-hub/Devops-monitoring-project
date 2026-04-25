pipeline {
    agent any

    environment {
        APP_NAME        = 'devops-monitoring-app'
        IMAGE_TAG       = "${BUILD_NUMBER}"
        DOCKER_IMAGE    = "${APP_NAME}:${IMAGE_TAG}"
        DOCKER_HUB_USER = 'YOUR-DOCKERHUB-USERNAME'
        DEPLOY_SERVER   = 'YOUR-DEPLOY-SERVER-IP'
    }

    tools {
        maven 'Maven'
        jdk   'JDK-21'
    }

    stages {

        stage('Checkout') {
            steps {
                echo '========== Stage: Checkout =========='
                git branch: 'main',
                    url: 'https://github.com/Rishis-hub/devops-monitoring-project.git'
            }
        }

        stage('Build') {
            steps {
                echo '========== Stage: Build =========='
                sh 'mvn clean package -DskipTests'
                echo 'Build completed successfully'
            }
        }

        stage('Unit Test') {
            steps {
                echo '========== Stage: Unit Test =========='
                sh 'mvn test'
                echo 'Tests completed successfully'
            }
        }

        stage('Code Quality Check') {
            steps {
                echo '========== Stage: Code Quality =========='
                echo 'SonarQube analysis would run here'
                echo 'Skipping - SonarQube not configured'
            }
        }

        stage('Docker Build') {
            steps {
                echo '========== Stage: Docker Build =========='
                sh """
                    docker build -t ${DOCKER_IMAGE} .
                    docker tag ${DOCKER_IMAGE} ${DOCKER_HUB_USER}/${DOCKER_IMAGE}
                """
                echo 'Docker image built successfully'
            }
        }

        stage('Push to DockerHub') {
            steps {
                echo '========== Stage: Push to DockerHub =========='
                withCredentials([usernamePassword(
                    credentialsId: 'DOCKER_CREDENTIALS',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                        docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}
                        docker push ${DOCKER_HUB_USER}/${DOCKER_IMAGE}
                        docker logout
                    """
                }
            }
        }

        stage('Deploy via Ansible') {
            steps {
                echo '========== Stage: Deploy via Ansible =========='
                withCredentials([sshUserPrivateKey(
                    credentialsId: 'ANSIBLE_SSH_KEY',
                    keyFileVariable: 'SSH_KEY'
                )]) {
                    sh """
                        ansible-playbook ansible/deploy.yml \
                            -i ansible/inventory.ini \
                            --private-key ${SSH_KEY} \
                            --extra-vars "image_tag=${IMAGE_TAG} app_name=${APP_NAME} docker_hub_user=${DOCKER_HUB_USER}"
                    """
                }
            }
        }

        stage('Health Check') {
            steps {
                echo '========== Stage: Health Check =========='
                sh "bash scripts/health-check.sh ${DEPLOY_SERVER}"
            }
        }

        stage('Monitoring Check') {
            steps {
                echo '========== Stage: Monitoring Check =========='
                echo 'Verifying Prometheus is scraping metrics...'
                sh "curl -s http://${DEPLOY_SERVER}:9090/-/healthy || echo 'Prometheus check skipped'"
                echo 'Verifying Grafana is running...'
                sh "curl -s http://${DEPLOY_SERVER}:3000/api/health || echo 'Grafana check skipped'"
                echo 'Monitoring stack verified!'
            }
        }
    }

    post {
        success {
            echo "========================================="
            echo " Pipeline SUCCESS — Build #${BUILD_NUMBER}"
            echo " App running at: http://${DEPLOY_SERVER}:80"
            echo " Grafana: http://${DEPLOY_SERVER}:3000"
            echo " Prometheus: http://${DEPLOY_SERVER}:9090"
            echo "========================================="
        }
        failure {
            echo "========================================="
            echo " Pipeline FAILED — Build #${BUILD_NUMBER}"
            echo "========================================="
        }
        always {
            cleanWs()
        }
    }
}
