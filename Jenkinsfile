pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh 'docker-compose build'
      }
    }
    stage('Parallel QA') {
      parallel {
        stage('Trivy fs') {
          steps {
            sh 'trivy fs -f json -o results.json .'
          }
          post {
            success {
              recordIssues(tools: [trivy(pattern: 'results.json')])
            }
          }
        }
        stage('Trivy container') {
          steps {
            sh 'trivy image -f json -o resultsC.json vue2048'
          }
          post {
            success {
              recordIssues(tools: [trivy(pattern: 'resultsC.json')])
            }
          }
        }
      }
    }
    stage('Publish') {
      steps {
        sshagent(['ssh-gitkey']) {
          sh 'git tag BUILD-1.0.${BUILD_NUMBER}'
          sh 'git push --tags'
        }
      }
    }
  }
}
