pipeline {
    agent { label 'jenkins-jenkins-agent' }
    environment {
        HARBOR_URL = "tkavna123"
        CI_PROJECT_PATH="spring-sample"
        APP_NAME="spring"
    }
      stages {
        stage('build maven') {
            steps {
                container('maven') {
                sh 'ls -al'
                sh 'mvn package'
                sh 'git log | sed -n 5p > log.txt'
                sh 'LOG=`cat log.txt`'
                }
            }
        }
        stage('build kaniko') {
            steps {//docker를 대체하여 kaniko 컨테이너를 사용하여 harbor에 push
                container('kaniko'){
                    echo $dockerconfig > /kaniko/.docker/config.json
                    sh '/kaniko/executor --context ./ --dockerfile ./Dockerfile --destination $HARBOR_URL/$CI_PROJECT_PATH/$APP_NAME:${BUILD_NUMBER}'
                }
            }
        }
        stage('push gitlab argo') {
            steps { // 미리 git에 연결된 ssh key 넣어둔 custom image를 사용하여 deploy 업데이트 
                git branch: 'main', credentialsId: 'macbook', url: 'https://github.com/sRrAiN98/spring_boot_test_helm.git'{
                    script {
                        sh'''
                        sed -i 's|tag: .*|tag: ${BUILD_NUMBER}|'  values.yaml
                        git add values.yaml && git commit -m "$LOG" && git push origin main
                        '''
                        // VALUES 파일 tag을 yq명령어로 수정하여 git commit & push 
                    }
                }
            }
        }
    }
}
