pipeline {
     parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        BASTION_SSH_CREDENTIALS = credentials('bastion_ssh_key')
        BASTION_IP_AZ1 = ''
        BASTION_IP_AZ2 = ''
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

        stage('Fetch Bastion IP') {
            steps {
                // Fetch the Bastion IP from Terraform output and store it in an environment variable
                script {
                    BASTION_IP_AZ1 = sh(script: 'terraform output -raw bastion_public_ip_AZ1', returnStdout: true).trim()
                    BASTION_IP_AZ2 = sh(script: 'terraform output -raw bastion_public_ip_AZ2', returnStdout: true).trim()
                }
            }
        }

        stage('Copy Ansible Files') {
            steps {
                // Check if Bastion IP was successfully fetched
                script {
                    if (BASTION_IP_AZ1 != null && BASTION_IP_AZ1 != '') {
                        sh """
                            echo "$BASTION_SSH_CREDENTIALS" > tera.pem
                            chmod 600 tera.pem
                            scp -i tera.pem -r ansible/* ubuntu@${BASTION_IP_AZ1}:/home/ubuntu/
                        """
                    } else {
                        error "Bastion public IP 1 not available."
                    }
                    if (BASTION_IP_AZ2 != null && BASTION_IP_AZ2 != '') {
                        sh """
                            echo "$BASTION_SSH_CREDENTIALS" > tera.pem
                            chmod 600 tera.pem
                            scp -i tera.pem -r ansible/* ubuntu@${BASTION_IP_AZ2}:/home/ubuntu/
                        """
                    } else {
                        error "Bastion public IP 2 not available."
                    }
                }
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                // SSH into the Bastion and run the Ansible playbook
                script {
                    if (BASTION_IP_AZ1 != null && BASTION_IP_AZ1 != '') {
                        sh """
                            ssh -i tera.pem ubuntu@${BASTION_IP_AZ1} -t ansible-playbook -i hosts docker_install.yml
                        """
                    } else {
                        error "Bastion public IP 1 not available."
                    }
                    if (BASTION_IP_AZ2 != null && BASTION_IP_AZ2 != '') {
                        sh """
                            ssh -i tera.pem ubuntu@${BASTION_IP_AZ2} -t ansible-playbook -i hosts docker_install.yml
                        """
                    } else {
                        error "Bastion public IP 2 not available."
                    }
                }
            }
        }
    }
}
