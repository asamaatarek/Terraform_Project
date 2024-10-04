pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git "https://github.com/asamaatarek/Terraform_Project.git"
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform init'
                sh 'terraform plan -out tf.tfstate'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Copy Ansible Files') {
            steps {
                sh 'scp -i tera.pem ansible/* ubuntu@bastion-ip'
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                sh 'ssh -i tera.pem ubuntu@bastion-ip -t ansible-playbook -i hosts docker_install.yml'
            }
        }
    }
}
