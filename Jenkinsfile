pipeline {
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        BASTION_IP_AZ1 = ''
        BASTION_IP_AZ2 = ''
    }
    agent any

    stages {
        stage('Checkout') {
            steps {
                script{
                    dir("terraform") {
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
                sh 'cd terraform/ ; terraform apply -auto-approve'
            }
        }

        stage('Fetch Bastion IP') {
            steps {
                script {
                    BASTION_IP_AZ1 = sh(script: 'terraform output -raw bastion_public_ip_AZ1', returnStdout: true).trim()
                    BASTION_IP_AZ2 = sh(script: 'terraform output -raw bastion_public_ip_AZ2', returnStdout: true).trim()
                    echo "Bastion IP AZ1: ${BASTION_IP_AZ1}"
                    echo "Bastion IP AZ2: ${BASTION_IP_AZ2}"
                }
            }
        }

        stage('Copy Ansible Files') {
            steps {
                script {

                     if (BASTION_IP_AZ1 != null && BASTION_IP_AZ1 != '') {
                        echo "Bastion IP AZ1: ${BASTION_IP_AZ1}"
                        withCredentials([file(credentialsId: 'tera-pem', variable: 'PEM_FILE')]) {
                            echo "Using PEM file: $PEM_FILE"
                            sh """
                                chmod 400 $PEM_FILE
                                scp -vvv -i $PEM_FILE -r ansible/* ubuntu@${BASTION_IP_AZ1}:/home/ubuntu/
                            """
                        }
                    } else {
                        error "Bastion public IP 1 not available."
                    }
                    /*if (BASTION_IP_AZ1 != null && BASTION_IP_AZ1 != '') {
                        withCredentials([file(credentialsId: 'tera-pem', variable: 'PEM_FILE')]) {
                            sh """
                                chmod 400 $PEM_FILE
                                scp -i $PEM_FILE -r ansible/* ubuntu@${BASTION_IP_AZ1}:/home/ubuntu/
                            """
                        }
                    } else {
                        error "Bastion public IP 1 not available."
                    }*/

                    if (BASTION_IP_AZ2 != null && BASTION_IP_AZ2 != '') {
                        withCredentials([file(credentialsId: 'tera-pem', variable: 'PEM_FILE')]) {
                            sh """
                                chmod 400 $PEM_FILE
                                scp -i $PEM_FILE -r ansible/* ubuntu@${BASTION_IP_AZ2}:/home/ubuntu/
                            """
                        }
                    } else {
                        error "Bastion public IP 2 not available."
                    }
                }
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                script {
                    if (BASTION_IP_AZ1 != null && BASTION_IP_AZ1 != '') {
                        withCredentials([file(credentialsId: 'tera-pem', variable: 'PEM_FILE')]) {
                            sh """
                                ssh -i $PEM_FILE ubuntu@${BASTION_IP_AZ1} -t ansible-playbook -i hosts docker_install.yml
                            """
                        }
                    } else {
                        error "Bastion public IP 1 not available."
                    }

                    if (BASTION_IP_AZ2 != null && BASTION_IP_AZ2 != '') {
                        withCredentials([file(credentialsId: 'tera-pem', variable: 'PEM_FILE')]) {
                            sh """
                                ssh -i $PEM_FILE ubuntu@${BASTION_IP_AZ2} -t ansible-playbook -i hosts docker_install.yml
                            """
                        }
                    } else {
                        error "Bastion public IP 2 not available."
                    }
                }
            }
        }
    }
}