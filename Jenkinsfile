pipeline {
    agent any

    parameters {
        string(name:'repoUrl', defaultValue:'https://github.com/tangjoe/java-shopping.git', description:'代码路径')
    }

    environment {
        SHOPFRONT = "shopfront"
        PRODUCTCATALOGUE = "productcatalogue"
        STOCKMANAGER = "stockmanager"
    }

    tools {
        maven 'maven3.6'
        jdk   'jdk8'
    }

    stages {

        stage('git: checkout source') {
            steps {
                echo "// git: checkout source"
                git url:params.repoUrl
            }
        }

/*
        stage('maven: shopfront compile & test & package') {
            steps {
                echo "// maven: shopfront compile & test & package"
                sh 'cd shopfront; mvn clean test package'
            }
        }

        stage('maven: productcatalogue compile & test & package') {
            steps {
                echo "// maven: productcatalogue compile & test & package"
                sh 'cd productcatalogue; mvn clean test package package'
            }
        }

        stage('maven: stockmanager compile & test & package') {
            steps {
                echo "// maven: stockmanager compile & test & package"
                sh 'cd stockmanager; mvn clean test package package'
            }
        }
*/

        stage('docker: shopfront build image') {
            steps {
                echo "// docker: shopfront build image"
                sh 'cd shopfront; docker build -t localhost:8082/shopfront:1.0 -f Dockerfile-build-n-run-stage .'
            }
        }

        stage('docker: productcatalogue build image') {
            steps {
                echo "// docker: productcatalogue build image"
                sh 'cd productcatalogue; docker build -t localhost:8082/productcatalogue:1.0 -f Dockerfile-build-n-run-stage .'
            }
        }

        stage('docker: stockmanager build image') {
            steps {
                echo "// docker: stockmanager build image"
                sh 'cd stockmanager; docker build -t localhost:8082/stockmanager:1.0 -f Dockerfile-build-n-run-stage .'
            }
        }

        stage('docker: push image to Nexus') {
            steps {
                echo "// docker: push image to Nexus"
                sh 'docker login -u docker -p P@ssw0rd localhost:8082'
                sh 'docker push localhost:8082/shopfront:1.0'
                sh 'docker push localhost:8082/productcatalogue:1.0'
                sh 'docker push localhost:8082/stockmanager:1.0'
            }
        }
        stage('docker-compose: end-to-end test') {
            steps {
                script {
                    echo "// docker-compose: end-to-end test"
                    timeout(time: 120, unit: 'SECONDS') {
                        try {
                            sh 'docker-compose up -d'
                            waitUntil {
                                def r = sh script:
                                // healthcheck
                                'curl http://shopfront:8010/health | grep "UP"', returnStatus: true
                                return (r == 0);
                            }
                            // main test here
                            sh 'curl http://shopfront:8010/ | grep "Docker Java"'
                            sh 'curl -s http://productcatalogue:8020/products | jq'
                            sh 'curl -s http://stockmanager:8030/stocks | jq'
                        } finally {
                            // Can't use docker-compose down as it will delete 'cicd_net' which is shared with Jenkins
                            // sh 'docker-compose down'
                            // sh 'docker rm -f shopfront productcatalogue stockmanager'
                        }
                    }
                }
            }
        }
    }
}
