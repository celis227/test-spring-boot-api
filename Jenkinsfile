pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'spring-boot-app'
        DOCKER_CREDENTIALS = 'dockerhub-credentials'
        USERNAME = 'celis227'
    }
    stages {
        stage('Checkout Code') {
            steps {
                echo "Cloning the Code"
                git url: 'https://github.com/celis227/test-spring-boot-api.git', branch: 'main'
            }
        }
        stage('Build JAR') {
            steps {
                echo "Building JAR file with Maven"
                sh "mvn clean package -DskipTests"
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    env.COMMIT_HASH = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    env.IMAGE_TAG = "${COMMIT_HASH}"
                    echo "Generated Image Tag: ${IMAGE_TAG}"
                    
                    echo "Building Docker Image with Tag: ${IMAGE_TAG}"
                    sh "docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} ."
                }
            }
        }
        stage('Deploy Locally and Health Check') {
            steps {
                script {
                    echo "Updating docker-compose.yaml to use the locally built image"
                    sh """
                    sed -i 's|image: ${USERNAME}/${DOCKER_IMAGE}:.*|image: ${DOCKER_IMAGE}:${IMAGE_TAG}|g' docker-compose.yaml
                    """
                    echo "docker-compose.yaml updated:"
                    sh "cat docker-compose.yaml"
                    
                    echo "Deploying the Application Locally with docker-compose"
                    sh "/usr/local/bin/docker-compose down"
                    sh "/usr/local/bin/docker-compose up -d"
                    
                    def maxRetries = 3
                    def retryCount = 0
                    def healthCheckPassed = false
                    
                    while (retryCount < maxRetries) {

                        def healthStatus = sh(script: """
                            curl -s -o /dev/null -w '%{http_code}' --connect-timeout 5 --max-time 10 http://host.docker.internal:8081/actuator/health || echo "FAILED"
                        """, returnStdout: true).trim()
                        
                        if (healthStatus == "200") {
                            healthCheckPassed = true
                            break
                        } else {
                            echo "Health check(Respuesta: ${healthStatus}). Retrying... (Try ${retryCount + 1}/${maxRetries})"
                            sleep(10)
                            retryCount++
                        }
                    }
                    
                    if (!healthCheckPassed) {
                        error "Health check failed after ${maxRetries} tries."
                    }
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                echo "Logging into Docker Hub"
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS}", passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin"
                }
                
                echo "Tagging and Pushing Docker Image"
                sh "docker tag ${DOCKER_IMAGE}:${IMAGE_TAG} ${USERNAME}/${DOCKER_IMAGE}:${IMAGE_TAG}"
                sh "docker push ${USERNAME}/${DOCKER_IMAGE}:${IMAGE_TAG}"
            }
        }
    }
}