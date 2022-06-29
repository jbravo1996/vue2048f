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
              recordIssues(tools: [trivy(id: 'trivyfs', pattern: 'results.json')])
            }
          }
        }
        stage('Trivy container') {
          steps {
            sh 'trivy image -f json -o resultsC.json nginx'
          }
          post {
            success {
              recordIssues(tools: [trivy(id: 'trivyC', pattern: 'resultsC.json')])
            }
          }
        }
      }
    }
    stage('Docker push'){
      steps{
        withCredentials([string(credentialsId: 'docker-tk', variable: 'var')]) {
              sh 'echo $var | docker login -u jbravo1996 --password-stdin'
              sh 'docker push jbravo1996/vue2048f:latest'
        }
      }
    }
    stage('Docker push on GitHub'){
      steps{
        withCredentials([string(credentialsId: 'ssh-gitkey', keyFileVariable: '')]) {
              //sh 'echo $var2 | docker login -u jbravo1996 --password-stdin'
              sh 'docker push ghcr.io/jbravo1996/jbravo1996/vue2048f:latest'
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
