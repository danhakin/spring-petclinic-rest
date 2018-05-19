pipeline {
    agent any
    environment {
        CI = 'true'
    }
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/danhakin/spring-petclinic-rest.git', credentialsId: 'github-danhakin', branch: 'master'            
            }
        }
        stage('Build image') {
            steps {
                script {
                    app = docker.build("spring-petclinic-rest:${env.BUILD_ID}")
                }
            }
        }
        stage('Unit Test') {
            steps {
                script {
                    app.inside {
                        sh 'pwd'
                        sh "mvn clean install"
                    }
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
                    docker.withRegistry("https://935517557789.dkr.ecr.eu-west-1.amazonaws.com/spring-petclinic-rest","ecr:eu-west-1:aws-ecr-repo"){
                        app.push()
                    }
                }
            }
        }
        stage('Deliver') {
            steps {
                sh 'echo Deploying to ECS cluster'
                sh './deploy.sh'
            }
        }
    }
}