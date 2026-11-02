
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
                    sh 'terraform fmt -recursive'
                    sh 'terraform fmt -check -recursive'
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Destroy Plan') {
            steps {
                dir('terraform') {
                    sh '''
                        terraform plan \
                          -destroy \
                          -input=false \
                          -var="project_id=${GOOGLE_PROJECT}" \
                          -out=tfplan

                        terraform show tfplan
                    '''
                }
            }
        }

        stage('Manual Approval') {
            steps {
                script {
                    input(
                        message: 'WARNING: This will permanently destroy the GCP infrastructure. Have you reviewed the Terraform destroy plan and confirmed the target project?',
                        ok: 'Approve Infrastructure Destruction',
                        submitter: 'YOUR_JENKINS_APPROVER'
                    )
                }
            }
        }

        stage('Terraform Destroy Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -input=false tfplan'
                }
            }
        }
    }

    post {
        success {
            echo 'Terraform infrastructure destruction completed successfully.'
        }

        failure {
            echo 'Terraform destruction failed. Check the Jenkins console output.'
        }

        always {
            sh 'rm -f terraform/tfplan'
        }
    }
}
