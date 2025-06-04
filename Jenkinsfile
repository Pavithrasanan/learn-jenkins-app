pipeline {
    agent any
    environment{
        NETLIFY_SITE_ID='77cff646-1686-4d4d-a46f-b90f4b4e8456'
        NETLIFY_AUTH_TOKEN=credentials('netlify_token')
        REACT_APP_VERSION= "1.0.$BUILD_ID"
    }

    stages {

        stage('AWS'){
            agent{
                docker{
                    image 'amazon/aws-cli'
                }
            }
            steps{
                sh'''
                aws --version 
                '''
            }
        }
       
        stage('Build') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
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

        stage('Run Tests') {
            parallel {
                stage('Test') {
                    agent {
                        docker {
                            image 'node:18-alpine'
                            reuseNode true
                        }
                    }
                    steps {
                        sh '''
                            echo "Testing"
                            test -f build/index.html
                            npm test
                        '''
                    }
                    post {
                        always {
                            junit 'jest-results/junit.xml'
                            publishHTML([
                                allowMissing: false,
                                alwaysLinkToLastBuild: false,
                                icon: '',
                                keepAll: false,
                                reportDir: 'playwright-report',
                                reportFiles: 'index.html',
                                reportName: 'Playwright HTML Report',
                                reportTitles: '',
                                useWrapperFileDirectly: true
                            ])
                        }
                    }
                }

                stage('E2E') {
                    agent {
                        docker {
                            image 'myplaywright'
                            reuseNode true
                        }

                    }
                    steps {
                        sh '''
                            serve -s build &
                            sleep 10
                            npx playwright test --reporter=html
                        '''
                    }
                    post {
                        always {
                            junit 'jest-results/junit.xml'
                            publishHTML([
                                allowMissing: false,
                                alwaysLinkToLastBuild: false,
                                icon: '',
                                keepAll: false,
                                reportDir: 'playwright-report',
                                reportFiles: 'index.html',
                                reportName: ' E2E',
                                reportTitles: '',
                                useWrapperFileDirectly: true
                            ])
                        }
                    }
                }
            }
        }

         stage('Deploy') {
            agent {
                docker {
                    image 'myplaywright'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    
                    npm ci
                    netlify --version
                    npm run build
                    test -d build
                    ls -ltr
                    echo "Deploying to production. Site ID: $NETLIFY_SITE_ID"
                    netlify status
                    npx netlify deploy --dir=build  --no-build --json > deploy_output.json
                    

                '''
                  script{
                env.STAGING_URL = sh(script: 'jq -r ".deploy_url" deploy_output.json', returnStdout: true)
                    }
              
            }
             
           
        }
        stage('Stating  E2E') {
                    agent {
                        docker {
                            image 'myplaywright'
                            reuseNode true
                        }
                    }
                    environment{
                            CI_ENVIRONMENT_URL = "${env.STAGING_URL}"
                        }
                    steps {
                        sh '''
                            serve -s build &
                            sleep 10
                            npx playwright test --reporter=html
                        '''
                    }
                    post {
                        always {
                            junit 'jest-results/junit.xml'
                            publishHTML([
                                allowMissing: false,
                                alwaysLinkToLastBuild: false,
                                icon: '',
                                keepAll: false,
                                reportDir: 'playwright-report',
                                reportFiles: 'index.html',
                                reportName: 'Local E2E',
                                reportTitles: '',
                                useWrapperFileDirectly: true
                            ])
                        }
                    }
                }
            

        stage('Prod Deploy') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            steps {

                
                sh '''
                    npm install netlify-cli
                    npm ci
                    node_modules/.bin/netlify --version
                    npm run build
                    test -d build
                    ls -ltr
                    echo "Deploying to production. Site ID: $NETLIFY_SITE_ID"
                    node_modules/.bin/netlify status
                    npx netlify deploy --dir=build --prod --no-build

                '''
            }
        }
        stage('Prod E2E') {
                    agent {
                        docker {
                            image 'myplaywright'
                            reuseNode true
                        }
                    }
                    environment{
                            CI_ENVIRONMENT_URL = 'http://localhost:3000'
                        }
                    steps {
                        sh '''
                            serve -s build &
                            sleep 10
                            npx playwright test --reporter=html
                        '''
                    }
                    post {
                        always {
                            junit 'jest-results/junit.xml'
                            publishHTML([
                                allowMissing: false,
                                alwaysLinkToLastBuild: false,
                                icon: '',
                                keepAll: false,
                                reportDir: 'playwright-report',
                                reportFiles: 'index.html',
                                reportName: 'Prod E2E',
                                reportTitles: '',
                                useWrapperFileDirectly: true
                            ])
                        }
                    }
                }
    }
}
