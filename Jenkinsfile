pipeline {
    agent any

    environment {
        GIT_REPO = 'https://github.com/prashantmukadam16/GCP-Infracode.git'
        GIT_BRANCH = 'main'
        GOOGLE_PROJECT = 'project-88c619e6-27a3-4887-94b'
        TF_IN_AUTOMATION = 'true'
        TF_INPUT = 'false'
    }

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: "${GIT_BRANCH}",
                    url: "${GIT_REPO}"
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init -input=false'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('terraform') {
                    sh 'terraform fmt -check -recursive'
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh '''
                        terraform plan \
                          -input=false \
                          -var="project_id=${GOOGLE_PROJECT}" \
                          -out=tfplan
                    '''
                }
            }
        }

        stage('Manual Approval') {
            steps {
                script {
                    def approval = input(
                        message: 'Review the Terraform plan. Approve deployment to GCP?',
                        ok: 'Approve and Deploy',
                        submitter: 'YOUR_JENKINS_APPROVER',
                        submitterParameter: 'APPROVED_BY'
                    )

                    echo "Deployment approved by: ${approval}"
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -input=false tfplan'
                }
            }
        }
    }

    post {
        always {
            sh 'rm -f terraform/tfplan'
        }
    }
}
