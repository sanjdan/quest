#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to deploy a CloudFormation stack
function deploy_stack() {
    stack_name=$1
    template_file=$2
    parameters_file=$3

    echo "Deploying stack: $stack_name"
    aws cloudformation deploy \
        --stack-name $stack_name \
        --template-file $template_file \
        --parameter-overrides file://$parameters_file \
        --capabilities CAPABILITY_NAMED_IAM
}

# Deploy stacks in sequence
# Ensure the correct order based on dependencies

deploy_stack "VPCStack" "templates/vpc.yml" "parameters/vpc-parameters.json"
deploy_stack "KMSStack" "templates/kms.yml" "parameters/kms-parameters.json"
deploy_stack "IAMStack" "templates/iam.yml" "parameters/iam-parameters.json"
deploy_stack "ECRStack" "templates/ecr.yml" "parameters/ecr-parameters.json"
deploy_stack "DLQStack" "templates/dlq.yml" "parameters/dlq-parameters.json"
deploy_stack "ECSBackendStack" "templates/ecs-backend.yml" "parameters/ecs-backend-parameters.json"
deploy_stack "ECSFrontendStack" "templates/ecs-frontend.yml" "parameters/ecs-frontend-parameters.json"

echo "All stacks deployed successfully."
