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
                 dir("terraform") {
                    script {
                        BASTION_IP_AZ1 = sh(script: 'terraform output -raw bastion_public_ip_AZ1', returnStdout: true).trim()
                        BASTION_IP_AZ2 = sh(script: 'terraform output -raw bastion_public_ip_AZ2', returnStdout: true).trim()
                        echo "Bastion IP AZ1: ${BASTION_IP_AZ1}"
                        echo "Bastion IP AZ2: ${BASTION_IP_AZ2}"
                    }
                }
            }
        }

        stage('Copy Ansible Files') {
            steps {
                script {
                    if (BASTION_IP_AZ1 != null && BASTION_IP_AZ1 != '') {
                        withCredentials([sshUserPrivateKey(credentialsId: 'tera-pem', keyFileVariable: 'PEM_FILE', usernameVariable: 'ubuntu')]) {
                            sh """#!/bin/bash
                                chmod 400 $PEM_FILE
                                scp -o StrictHostKeyChecking=no -i $PEM_FILE -r ansible/ ubuntu@${BASTION_IP_AZ1}:/home/ubuntu/
                            """
                        }
                    } else {
                        error "Bastion public IP 1 not available."
                    }

                    if (BASTION_IP_AZ2 != null && BASTION_IP_AZ2 != '') {
                        withCredentials([sshUserPrivateKey(credentialsId: 'tera-pem', keyFileVariable: 'PEM_FILE', usernameVariable: 'ubuntu')]) {
                            sh """#!/bin/bash
                                chmod 400 $PEM_FILE
                                scp -o StrictHostKeyChecking=no -i $PEM_FILE -r ansible/ ubuntu@${BASTION_IP_AZ2}:/home/ubuntu/
                            """
                        }
                    } else {
                        error "Bastion public IP 2 not available."
                    }
                }
            }
        }
        stage('Generate Ansible Inventory') {
            steps {
                script {
                def privateIPsAZ1 = sh(script: 'terraform output -raw private_instance_az1', returnStdout: true).trim()
                def privateIPsAZ2 = sh(script: 'terraform output -raw private_instance_az2', returnStdout: true).trim()
                    
                writeFile file: 'ansible/roles/docker_nginx/tests/inventory', text: """
                [private_servers]
                ${privateIPsAZ1}
                ${privateIPsAZ2}

                private_servers:vars]
                ansible_user=ubuntu
                """
                    
                }
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                script {
                    if (BASTION_IP_AZ1 != null && BASTION_IP_AZ1 != '') {
                        withCredentials([sshUserPrivateKey(credentialsId: 'tera-pem', keyFileVariable: 'PEM_FILE', usernameVariable: 'ubuntu')]) {
                            sh """#!/bin/bash
                                chmod 400 $PEM_FILE
                                ssh -o StrictHostKeyChecking=no -i $PEM_FILE ubuntu@${BASTION_IP_AZ1} '
                                    echo "Listing files in /home/ubuntu/ansible:"
                                    ls -l /home/ubuntu/ansible/
                                    if ! command -v ansible-playbook &> /dev/null
                                    then
                                        echo "Ansible not found. Installing..."
                                        sudo DEBIAN_FRONTEND=noninteractive apt-get update
                                        sudo DEBIAN_FRONTEND=noninteractive apt-get install -y ansible
                                    fi
                                    if [ -f "/home/ubuntu/ansible/deploy_nginx.yml" ]
                                    then
                                        ansible-playbook -i /home/ubuntu/ansible/roles/docker_nginx/tests/inventory /home/ubuntu/ansible/deploy_nginx.yml
                                    else
                                        echo "Playbook deploy_nginx.yml not found in /home/ubuntu/ansible"
                                        exit 1
                                    fi
                                '
                            """
                        }
                    } else {
                        error "Bastion public IP 1 not available."
                    }

                    if (BASTION_IP_AZ2 != null && BASTION_IP_AZ2 != '') {
                        withCredentials([sshUserPrivateKey(credentialsId: 'tera-pem', keyFileVariable: 'PEM_FILE', usernameVariable: 'ubuntu')]) {
                            sh """#!/bin/bash
                                chmod 400 $PEM_FILE
                                ssh -o StrictHostKeyChecking=no -i $PEM_FILE ubuntu@${BASTION_IP_AZ2} '
                                    echo "Listing files in /home/ubuntu/ansible:"
                                    ls -l /home/ubuntu/ansible/
                                    if ! command -v ansible-playbook &> /dev/null
                                    then
                                        echo "Ansible not found. Installing..."
                                        sudo DEBIAN_FRONTEND=noninteractive apt-get update
                                        sudo DEBIAN_FRONTEND=noninteractive apt-get install -y ansible
                                    fi
                                    if [ -f "/home/ubuntu/ansible/deploy_nginx.yml" ]
                                    then
                                        ansible-playbook -i /home/ubuntu/ansible/roles/docker_nginx/tests/inventory /home/ubuntu/ansible/deploy_nginx.yml
                                    else
                                        echo "Playbook deploy_nginx.yml not found in /home/ubuntu/ansible/"
                                        exit 1
                                    fi
                                '
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