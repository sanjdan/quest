#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Variables
ECR_REPO_NAME=$1
IMAGE_TAG=$2

# Check if ECR_REPO_NAME and IMAGE_TAG are provided
if [ -z "$ECR_REPO_NAME" ] || [ -z "$IMAGE_TAG" ]; then
    echo "Usage: $0 <ecr-repo-name> <image-tag>"
    exit 1
fi

# Get AWS Account ID and Region
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
AWS_REGION=$(aws configure get region)

# Build Docker image
DOCKER_IMAGE="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME:$IMAGE_TAG"
echo "Building Docker image: $DOCKER_IMAGE"
docker build -t $DOCKER_IMAGE .

# Authenticate Docker to ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Push Docker image to ECR
echo "Pushing Docker image to ECR"
docker push $DOCKER_IMAGE

echo "Docker image pushed successfully: $DOCKER_IMAGE"
