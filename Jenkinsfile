pipeline {
    agent any
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
        stage('Test') {
            steps {
                script {
                    app.inside {
                        sh 'pwd'
                        sh "mvn clean install"
                    }
                }
            }
        }
        stage('Deliver') {
            steps{
                sh 'echo delivering coming soon...'
            }
        }
    }
}