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
        sh 'docker-compose build'
      }
    }
    stage('Parallel QA') {
      when {
        expression {
          false
        }
      }
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
    stage('EC2 Instance+ Ansible Playbook') {
      steps {
        withAWS(credentials: 'Admin-AWS', endpointUrl: 'https://117876762515.signin.aws.amazon.com/console', region: 'eu-west-1') {
          sh '''cd terraform
                terraform init
                terraform apply -auto-approve'''
          ansiblePlaybook colorized: true, credentialsId: 'ssh-ansible', disableHostKeyChecking: true, inventory: './ansible/aws_ec2.yml', playbook: './ansible/ec2-provisioning.yml'
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
