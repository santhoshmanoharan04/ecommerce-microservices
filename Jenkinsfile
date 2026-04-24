stage('Deploy to EC2') {
    steps {
        sshagent(['ec2-ssh-key']) {
            sh '''
ssh -o StrictHostKeyChecking=no ubuntu@$EC2_IP << EOF

# Pull images
docker pull $DOCKER_HUB/product-service:$IMAGE_TAG
docker pull $DOCKER_HUB/cart-service:$IMAGE_TAG
docker pull $DOCKER_HUB/frontend:$IMAGE_TAG

# Create network (important)
docker network create ecommerce-net || true

# Run product-service
docker stop product || true
docker rm product || true
docker run -d --name product --network ecommerce-net -p 4000:4000 $DOCKER_HUB/product-service:$IMAGE_TAG

# Run cart-service
docker stop cart || true
docker rm cart || true
docker run -d --name cart --network ecommerce-net -p 5000:5000 $DOCKER_HUB/cart-service:$IMAGE_TAG

# Run frontend
docker stop frontend || true
docker rm frontend || true
docker run -d --name frontend --network ecommerce-net -p 3000:3000 $DOCKER_HUB/frontend:$IMAGE_TAG

EOF
'''
        }
    }
}
