node {
	def app
	stage('Clone repository') {
		git 'https://github.com/handagyeong/OpenSW_cheese.git'
	}
	stage('Build image') {
		app = docker.build("handa1/test")
	}
	stage('Push image') {
		docker.withRegistry('https://registry.hub.docker.com', 'handa1') {
		app.push("${env.BUILD_NUMBER}")
		app.push("latest")
		}
	}
}
