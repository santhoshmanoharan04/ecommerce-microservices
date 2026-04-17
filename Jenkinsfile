pipeline{
    agent any


        environment{
          DOCKER_HUB = "santhosh0476"
          IMAGE_TAG = "${BUILD_NUMBER}"
          EC2_IP = "16.171.29.75"
        }
    

    stages{
       stage ('clone'){
    steps{
        git url: 'https://github.com/santhoshmanoharan04/ecommerce-microservices.git'
    }
}
        stage('terraform init'){
        steps{
        sh 'terraform init'
        }
        }
    
       stage('terraform apply'){
        steps{
            sh 'terraform plan'
            sh 'terraform apply -auto-approve'
        }
       }
       stage('Build Docker Images'){
       steps{
        sh '''
         docker build -t $DOCKER_HUB/product-service:$IMAGE_TAG ./product-service
         docker build -t $DOCKER_HUB/cart-service:$IMAGE_TAG ./cart-service
         docker build -t $DOCKER_HUB/frontend:$IMAGE_TAG ./frontend
        '''
       }
       }
       stage('login docker'){
       steps{
        withCredentials([usernamePassword(
            credentialsId: 'docker-cred',
                    usernameVariable: 'USERNAME',
                    passwordVariable: 'TOKEN'

        ) ]){
            sh 'echo $TOKEN | docker login -u  $USERNAME --password-stdin'
        }
       }
       }
       stage('push image'){
        steps{
            sh '''
            docker push $DOCKER_HUB/product-service:$IMAGE_TAG
            docker push $DOCKER_HUB/cart-service:$IMAGE_TAG
            docker push $DOCKER_HUB/frontend:$IMAGE_TAG

            '''
        }
       }
       stage('Deploy to EC2'){
        steps{
            sshagent(['ec2-ssh-key']){
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
