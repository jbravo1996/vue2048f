pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                //git branch: 'main', url: 'https://github.com/rodauher/Hello-Springboot.git'
                sh "docker-compose build"
            }
            //post {
             //   success {
             //       junit 'build/test-results/test/*.xml'
             //       archiveArtifacts 'dist/_assets/*'
             //   }
            //}
        }
        stage('Publish'){
            steps {
                sshagent(['github-ssh']) {
                sh 'git tag BUILD-1.0.${BUILD_NUMBER}'
                sh 'git push --tags'
                }
            }
        }
    }
}
