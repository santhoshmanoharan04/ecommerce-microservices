pipeline {
    agent any

    environment {
        DOCKER_HUB = "santhosh0476"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Terraform') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'aws-cred',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                )]) {
                    sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY

                    terraform init
                    terraform plan
                    terraform apply -auto-approve
                    '''
                }
            }
        }

        stage('Get EC2 IP') {
            steps {
                script {
                    EC2_IP = sh(
                        script: "terraform output -raw ec2_public_ip",
                        returnStdout: true
                    ).trim()
                }
            }
        }

        stage('Login Docker') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-cred',
                    usernameVariable: 'USERNAME',
                    passwordVariable: 'TOKEN'
                )]) {
                    sh 'echo $TOKEN | docker login -u $USERNAME --password-stdin'
                }
            }
        }

        stage('Build Docker Images') {
            steps {
                sh '''
                docker build -t $DOCKER_HUB/product-service:$IMAGE_TAG ./product-service
                docker build -t $DOCKER_HUB/cart-service:$IMAGE_TAG ./cart-service
                docker build -t $DOCKER_HUB/frontend:$IMAGE_TAG ./frontend
                '''
            }
        }

        stage('Push Images') {
            steps {
                sh '''
                docker push $DOCKER_HUB/product-service:$IMAGE_TAG
                docker push $DOCKER_HUB/cart-service:$IMAGE_TAG
                docker push $DOCKER_HUB/frontend:$IMAGE_TAG
                '''
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-ssh-key']) {
                    sh '''
ssh -o StrictHostKeyChecking=no ubuntu@$EC2_IP << EOF

docker pull $DOCKER_HUB/frontend:$IMAGE_TAG

docker stop frontend || true
docker rm frontend || true

docker run -d -p 3000:3000 --name frontend $DOCKER_HUB/frontend:$IMAGE_TAG

EOF
'''
                }
            }
        }
    }
}
