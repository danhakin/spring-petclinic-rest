#!/bin/bash

# Login to ECR
DOCKER_LOGIN=`aws ecr get-login --region eu-west-1 --no-include-email`
${DOCKER_LOGIN}

# Prepare ECS Service
REGION=eu-west-1
REPOSITORY_NAME=spring-petclinic-rest
CLUSTER=ecs-devops
FAMILY=`sed -n 's/.*"family": "\(.*\)",/\1/p' taskdef.json`
NAME=`sed -n 's/.*"name": "\(.*\)",/\1/p' taskdef.json`
SERVICE_NAME=${NAME}-service

echo "-- Store the repositoryUri as a variable"
#Store the repositoryUri as a variable
REPOSITORY_URI=`aws ecr describe-repositories --repository-names ${REPOSITORY_NAME} --region ${REGION} | jq .repositories[].repositoryUri | tr -d '"'`

echo "-- Replace the build number and respository URI placeholders with the constants above"
#Replace the build number and respository URI placeholders with the constants above
sed -e "s;%BUILD_NUMBER%;${BUILD_NUMBER};g" -e "s;%REPOSITORY_URI%;${REPOSITORY_URI};g" taskdef.json > ${NAME}-${BUILD_NUMBER}.json

echo "-- Register the task definition in the repository"
#Register the task definition in the repository
aws ecs register-task-definition --family ${FAMILY} --cli-input-json file://${WORKSPACE}/${NAME}-${BUILD_NUMBER}.json --region ${REGION}
SERVICES=`aws ecs describe-services --services ${SERVICE_NAME} --cluster ${CLUSTER} --region ${REGION} | jq .failures[]`

echo "-- Get latest revision"
#Get latest revision
REVISION=`aws ecs describe-task-definition --task-definition ${NAME} --region ${REGION} | jq .taskDefinition.revision`

echo "-- Create or update service"
#Create or update service
if [ "$SERVICES" == "" ]; then
  echo "entered existing service"
  DESIRED_COUNT=`aws ecs describe-services --services ${SERVICE_NAME} --cluster ${CLUSTER} --region ${REGION} | jq .services[].desiredCount`
  if [ ${DESIRED_COUNT} = "0" ]; then
    DESIRED_COUNT="1"
  fi
  aws ecs update-service --cluster ${CLUSTER} --region ${REGION} --service ${SERVICE_NAME} --task-definition ${FAMILY}:${REVISION} --desired-count ${DESIRED_COUNT}
else
  echo "entered new service"
  aws ecs create-service --service-name ${SERVICE_NAME} --desired-count 1 --task-definition ${FAMILY} --cluster ${CLUSTER} --region ${REGION}
fi
