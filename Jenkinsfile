pipeline {
    agent { label 'jenkins-jenkins-agent' }
    environment {
        HARBOR_URL = "tkavna123"
        CI_PROJECT_PATH="spring-sample-test"
        //APP_NAME="spring"
    }
      stages {
        stage('build maven') {
            steps {
                container('maven') {
                    sh 'ls -al'
                    sh 'mvn package'
                }
            }
        }
        stage('build kaniko') {
            steps {//docker를 대체하여 kaniko 컨테이너를 사용하여 harbor에 push
                container('kaniko'){
                    withCredentials([string(credentialsId: 'dockerconfig', variable: 'dockerconfig')]) {
                        sh 'echo $dockerconfig > /kaniko/.docker/config.json'
                        sh '/kaniko/executor --context ./ --dockerfile ./Dockerfile --destination $HARBOR_URL/$CI_PROJECT_PATH:${BUILD_NUMBER}'
                    }
                }
            }
        }
        stage('push gitlab argo') {
            steps { // 미리 git에 연결된 ssh key 넣어둔 custom image를 사용하여 deploy 업데이트 
                script {
                    git credentialsId: '404ffe09-c99d-4f38-97f4-de8bba375d95', url: 'https://github.com/sRrAiN98/spring_boot_test_helm.git' 
                    sh 'git log | sed -n 5p > log.txt'
                    sh 'LOG=`cat log.txt`'
                    sh'''
                    sed -i 's|tag: .*|tag: ${BUILD_NUMBER}|'  values.yaml
                    echo 'hi'
                    git add values.yaml && git commit -m "$LOG" && git push origin main
                    '''
                }
            }
        }
    }
}
