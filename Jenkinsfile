pipeline {
    agent any
    options {
        ansiColor('xterm')
        timestamps()
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '5'))
    }
    stages {
        stage('Build') {
            steps {
               sh "docker-compose build"
            }
        }
        stage('Publish'){
            steps {
                sshagent(['ssh-gitkey']) {
                sh 'git tag BUILD-1.0.${BUILD_NUMBER}'
                sh 'git push --tags'
                }
            }
        }
        /*stage('Wait'){
            steps{
                sleep time: 20, unit: 'SECONDS'
            }

        } */
    }
}
