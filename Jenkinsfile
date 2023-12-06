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
                withCredentials([string(credentialsId: 'jwtsecret', variable: 'JWT_SECRET')]) {
                // deployment.yaml 파일 편집
                    sh "sed -i 's/jwtsecretvalue/${JWT_SECRET}/g' deployment.yaml"
                }
                step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'deployment.yaml', credentialsId: env.CREDENTIALS_ID, verifyDeployments: false])
            }
        }
    }    
}
