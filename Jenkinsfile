pipeline {
     parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    agent any

    stages {
        stage('Checkout') {
            steps {
                script{
                        dir("terraform")
                        {
                            git branch: 'main', url: 'https://github.com/asamaatarek/Terraform_Project.git'
                        }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("terraform") {
                    sh 'terraform init'
                    sh 'terraform plan -out tf.tfstate'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'pwd;cd terraform/ ; terraform apply -auto-approve'
            }
        }

        stage('Copy Ansible Files') {
            steps {
                sh 'pwd;cd ..;'
                sh 'scp -i tera.pem ansible/* ubuntu@bastion_public_ip_AZ1'
                sh 'scp -i tera.pem ansible/* ubuntu@bastion_public_ip_AZ2'
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                sh 'ssh -i tera.pem ubuntu@bastion_public_ip_AZ1 -t ansible-playbook -i hosts docker_install.yml'
                sh 'ssh -i tera.pem ubuntu@bastion_public_ip_AZ2 -t ansible-playbook -i hosts docker_install.yml'
            }
        }
    }
}
