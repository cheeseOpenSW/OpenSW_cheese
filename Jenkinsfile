pipeline {
    agent any
    environment {
        PROJECT_ID = 'inspiring-code-383107'
        CLUSTER_NAME = 'kube'
        LOCATION = 'asia-northeast3-a'
        CREDENTIALS_ID = 'b72863ff-bdd5-4ec3-8f0b-59c77facc352'
    }
    stages {
        stage("Checkout code") {
            steps {
                checkout scm
            }
        }
        stage("Build image") {
            steps {
                script {
                    myapp = docker.build("theunghee02/open-sw-cheese:${env.BUILD_ID}")
                }
            }
        }
        stage("Push image") {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'db4d86bd-9721-45bc-9f1a-bd50bca92f4c') {
                            myapp.push("latest")
                            myapp.push("${env.BUILD_ID}")
                    }
                }
            }
        }        
        stage('Deploy to GKE') {
			when {
				branch 'main'
			}
            steps{
                sh "sed -i 's/opensw_cheese:latest/opensw_cheese:${env.BUILD_ID}/g' deployment.yaml"
                //secret.js
                withCredentials([string(credentialsId: 'jwtsecret', variable: 'JWT_SECRET')]) {
                    sh "sed -i 's/jwtsecretvalue/${JWT_SECRET}/g' deployment.yaml"
                }
                //database.env
                withCredentials([string(credentialsId: 'DB_HOST', variable: 'DB_HOST')]) {
                    sh "sed -i 's/DB_HOSTvalue/${DB_HOST}/g' deployment.yaml"
                }
                withCredentials([string(credentialsId: 'DB_NAME', variable: 'DB_NAME')]) {
                    sh "sed -i 's/DB_NAMEvalue/${DB_NAME}/g' deployment.yaml"
                }
                withCredentials([string(credentialsId: 'DB_PORT', variable: 'DB_PORT')]) {
                    sh "sed -i 's/DB_PORTvalue/${DB_PORT}/g' deployment.yaml"
                }
                withCredentials([string(credentialsId: 'DB_USER', variable: 'DB_USER')]) {
                    sh "sed -i 's/DB_USERvalue/${DB_USER}/g' deployment.yaml"
                }
                withCredentials([string(credentialsId: 'DB_PW', variable: 'DB_PW')]) {
                    sh "sed -i 's/DB_PWvalue/${DB_PW}/g' deployment.yaml"
                }
                //gpt
                withCredentials([string(credentialsId: 'OPENAI_API_KEY', variable: 'OPENAI_API_KEY')]) {
                    sh "sed -i 's/OPENAI_API_KEYvalue/${OPENAI_API_KEY}/g' deployment.yaml"
                }
                //sens.env
                withCredentials([string(credentialsId: 'SENS_SERVICE_ID', variable: 'SENS_SERVICE_ID')]) {
                    sh "sed -i 's/SENS_SERVICE_IDvalue/${SENS_SERVICE_ID}/g' deployment.yaml"
                }
                withCredentials([string(credentialsId: 'SENS_ACCESS_KEY', variable: 'SENS_ACCESS_KEY')]) {
                    sh "sed -i 's/SENS_ACCESS_KEYvalue/${SENS_ACCESS_KEY}/g' deployment.yaml"
                }
                withCredentials([string(credentialsId: 'SENS_MYPHONENUM', variable: 'SENS_MYPHONENUM')]) {
                    sh "sed -i 's/SENS_MYPHONENUMvalue/${SENS_MYPHONENUM}/g' deployment.yaml"
                }
                withCredentials([string(credentialsId: 'SENS_SECRET_KEY', variable: 'SENS_SECRET_KEY')]) {
                    sh "sed -i 's/SENS_SECRET_KEYvalue/${SENS_SECRET_KEY}/g' deployment.yaml"
                }
                step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'deployment.yaml', credentialsId: env.CREDENTIALS_ID, verifyDeployments: false])
            }
        }
    }    
}
