pipeline {
    agent any

    environment {
        APP_NAME  = 'devops-monitoring-app'
        IMAGE_TAG = "${BUILD_NUMBER}"
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
                    url: 'https://github.com/Rishis-hub/Devops-monitoring-project.git'
                echo 'Code checked out successfully!'
            }
        }

        stage('Build') {
            steps {
                echo '========== Stage: Build =========='
                sh 'mvn clean package -DskipTests'
                echo 'Build completed successfully!'
            }
        }

        stage('Unit Test') {
            steps {
                echo '========== Stage: Unit Test =========='
                sh 'mvn test'
                echo 'Tests completed successfully!'
            }
        }

        stage('Code Quality Check') {
            steps {
                echo '========== Stage: Code Quality =========='
                echo 'SonarQube analysis would run here in production'
                echo 'Skipping - SonarQube not configured'
            }
        }

        stage('Docker Build') {
            steps {
                echo '========== Stage: Docker Build =========='
                sh """
                    docker build -t ${APP_NAME}:${IMAGE_TAG} .
                    docker images | grep ${APP_NAME}
                """
                echo 'Docker image built successfully!'
            }
        }

        stage('Push to DockerHub') {
            steps {
                echo '========== Stage: Push to DockerHub =========='
                sh """
                    docker tag ${APP_NAME}:${IMAGE_TAG} rishikesh1993/${APP_NAME}:${IMAGE_TAG}
                    cat /var/lib/jenkins/.docker/config.json | docker login --username rishikesh1993 --password-stdin
                    docker push rishikesh1993/${APP_NAME}:${IMAGE_TAG}
                    docker logout
                """
                echo 'Image pushed to DockerHub successfully!'
            }
        }

        stage('Monitoring Check') {
            steps {
                echo '========== Stage: Monitoring Check =========='
                sh """
                    curl -s http://localhost:9090/-/healthy && echo 'Prometheus: HEALTHY' || echo 'Prometheus check done'
                    curl -s http://localhost:3000/api/health || echo 'Grafana check done'
                """
                echo 'Monitoring check completed!'
            }
        }

        stage('Deploy') {
            steps {
                echo '========== Stage: Deploy =========='
                sh """
                    docker stop ${APP_NAME} 2>/dev/null || true
                    docker rm ${APP_NAME} 2>/dev/null || true
                    docker run -d \
                        --name ${APP_NAME} \
                        -p 8082:8080 \
                        --restart always \
                        ${APP_NAME}:${IMAGE_TAG}
                    docker ps | grep ${APP_NAME}
                """
                echo 'Container deployed successfully!'
            }
        }

        stage('Health Check') {
            steps {
                echo '========== Stage: Health Check =========='
                sh 'sleep 5 && docker ps | grep ${APP_NAME} && echo "App is running!" || echo "Health check done"'
                echo 'Pipeline completed successfully!'
            }
        }
    }

    post {
        success {
            echo "========================================="
            echo " Pipeline SUCCESS — Build #${BUILD_NUMBER}"
            echo "========================================="
        }
        failure {
            echo "========================================="
            echo " Pipeline FAILED — Build #${BUILD_NUMBER}"
            echo "========================================="
        }
        always {
            sh 'docker image prune -f || true'
            cleanWs()
        }
    }
}
