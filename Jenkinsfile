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
                    junit '**/target/surefire-reports/*.xml'
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