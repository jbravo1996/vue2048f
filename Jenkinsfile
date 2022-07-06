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
    stage('EC2 Instance+ Ansible Playbook'){
      steps{
        withAWS(credentials: 'Admin-AWS', endpointUrl: 'https://117876762515.signin.aws.amazon.com/console', region: 'eu-west-1') {
          ansiblePlaybook colorized: true, credentialsId: 'ssh-ansible', disableHostKeyChecking: true, playbook: 'ansible/ec2-docker.yml'
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
