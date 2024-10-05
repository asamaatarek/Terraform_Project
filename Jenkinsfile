pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
<<<<<<< HEAD
                git "https://github.com/asamaatarek/Terraform_Project.git"
=======
                git url: 'https://github.com/asamaatarek/Terraform_Project.git'
>>>>>>> 49caa15 (jenkins)
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
<<<<<<< HEAD
                sh 'scp -i tera.pem ansible/* ubuntu@bastion-ip'
=======
                sh 'scp -i tra.pem ansible/* ubuntu@bastion-ip'
>>>>>>> 49caa15 (jenkins)
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                sh 'ssh -i tera.pem ubuntu@bastion-ip -t ansible-playbook -i hosts docker_install.yml'
            }
        }
    }
}
