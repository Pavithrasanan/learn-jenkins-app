pipeline {
    agent any

    stages {
        stage('Build') {
            agent{
                docker{
                    image 'node:18-alpine'
		    reuseNode true
                }
            }
            steps {
                sh'''
                ls -la
                node --version
                npm --version
                npm ci
                npm run build
                ls -la
                echo "build success"
                '''
            }
        }
	stage('Test'){
	    steps{
		sh '''echo "Testing"
		test -f buil/index.html
		npm test
		'''
		}	
	}
    }

  
}
