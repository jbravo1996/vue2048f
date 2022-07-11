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
      when {
        expression {
          false
        }
      }
      steps {
        withAWS(credentials: 'Admin-AWS', endpointUrl: 'https://117876762515.signin.aws.amazon.com/console', region: 'eu-west-1') {
          sh '''cd terraform
                terraform init
                terraform apply -auto-approve'''
          ansiblePlaybook colorized: true, credentialsId: 'ssh-ansible', disableHostKeyChecking: true, inventory: './ansible/aws_ec2.yml', playbook: './ansible/ec2-provisioning.yml'
        }
      }
    }
    stage('Kubernetes deployment') {
      steps {
        withKubeCredentials(kubectlCredentials: [[caCertificate: '''-----BEGIN CERTIFICATE-----
MIIDBjCCAe6gAwIBAgIBATANBgkqhkiG9w0BAQsFADAVMRMwEQYDVQQDEwptaW5p
a3ViZUNBMB4XDTIyMDcwNzEzMDA0NFoXDTMyMDcwNTEzMDA0NFowFTETMBEGA1UE
AxMKbWluaWt1YmVDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKbV
TN2E0FoP6xKCtgU4P6Is5PBTtz5EumN1bXsvTab0nmlQnXGuKENhlPGb76igbBFt
WZsnEl2yBMaYZK2qreJ4rr1CepWyo0LRNcQ1LEQAD7tx89maiADhPZuzov62QEr2
ureY4MqPh0pkBjjxw7M3BVj+keJYsATnqS84EluRQ2shaVl2MHYjEl9CcWTfcZv/
lubgzOSocJPrpGu8Pi/EBVFRRhZK7MqVcr+6T60rPU6uIyxhYC/pjCOLB5wKMPX/
unbiiP+7LbZo9xWm9O5ushxhN7tDEBJjk2uyj3LoRX1GAR4HkekIB9rQy0HYtywF
yPDaKcAHobr+lQeJ0u8CAwEAAaNhMF8wDgYDVR0PAQH/BAQDAgKkMB0GA1UdJQQW
MBQGCCsGAQUFBwMCBggrBgEFBQcDATAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQW
BBRUTsJQrEIi7VgTvPXTYE7ObjpV5zANBgkqhkiG9w0BAQsFAAOCAQEAXLH5AawW
9QDVqT/vYhsYusJ9gjgMgWw1JKefmwT3yIlKv4/57eTxCTD7OOQbOKSZhWk9HcW7
cruYXNPaYLKT32qDB7vvZ/NvnijBzdvSLSWBtmnEPI6R9J8NGfkmU5dKoUAZcTbZ
TVAu2yHPCvsFvN8EqccWwjTR4iCynrAsm9BOALpvKNF50o3iSX0pEHlHkEXA8W3G
YI4CtRZOUD0dMZrkRAUT9dz7SbXZKQeHCxcfHrtvI8rEgNX4hwdD9nUFfdh8hmlT
Ow0+xpC9h4THhRGnuYNThyGiSctgEnWlliLmow3xT7NeiVXZD9tJG+radnhxKUgX
alQvzF6+MYkBhg==
-----END CERTIFICATE-----''', clusterName: 'minikube', contextName: '', credentialsId: 'kubectl', namespace: '', serverUrl: 'https://192.168.49.2:8443']]) {
          sh '''
kubectl get deployments
kubectl get pods
kubectl apply -f ./minikube/vue2048.yaml
kubectl get deployments
kubectl get pods
kubectl get service vue-service --output='jsonpath="{.spec.ports[0].nodePort}"'
    '''
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
