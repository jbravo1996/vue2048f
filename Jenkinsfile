pipeline {
    agent any
    options {
        ansiColor('xterm')
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
    }
}
