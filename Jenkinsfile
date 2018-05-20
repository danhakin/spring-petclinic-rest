pipeline {
    agent any
    environment {
        CI = 'true'
    }
    tools {
        maven 'M3'
        jdk 'jdk8'
    }
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/danhakin/spring-petclinic-rest.git', credentialsId: 'github-danhakin', branch: 'master'            
            }
        }
        stage('Unit Test') {
            steps {
                script {
                    sh 'pwd'
                    sh "mvn clean install"
                }
            }
            post {
               always {
                    archiveArtifacts artifacts: 'target/spring-petclinic-1.5.2.war', fingerprint: true
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }
        stage('Push image') {
            steps {
                sh 'echo Uploading docker image to ECR'
                script {
                    app = docker.build("spring-petclinic-rest:${env.BUILD_ID}")
                    docker.withRegistry("https://935517557789.dkr.ecr.eu-west-1.amazonaws.com/spring-petclinic-rest","ecr:eu-west-1:aws-ecr-repo"){
                        app.push()
                    }
                }
            }
        }
        stage('Build frontend') {
            steps {
                sh 'echo launch frontend job'
                build job: 'petclinic-front'
            }
        }
        // stage('Deliver') {
        //     steps {
        //         sh 'echo Deploying to ECS cluster'
        //         sh './deploy.sh'
        //     }
        // }
    }
}