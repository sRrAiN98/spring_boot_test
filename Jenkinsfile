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
            steps {
withCredentials([usernamePassword(credentialsId: 'sRrAiN', passwordVariable: 'GITPW', usernameVariable: 'GITUSER')]) {                      sh 'git log | sed -n 5p > log.txt'
                    git branch: 'main', credentialsId: 'sRrAiN', url: ''
                    sh 'git clone https://${GITUSER}:${GITPW}@$https://github.com/sRrAiN98/spring_boot_test_helm.git -b main'
                    sh'''
                    git config --global user.email "jenkins@example.com"
                    git config --global user.name "jenkins"
                    sed -i 's|tag: .*|tag: ${BUILD_NUMBER}|'  values.yaml
                    cat log.txt
                    LOG=`cat log.txt`
                    git add values.yaml && git commit -m "$LOG" 
                    git push
                    '''
                }
            }
        }
    }
}
