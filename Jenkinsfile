pipeline {
    agent { label 'jenkins-jenkins-agent' }
    environment {
        HARBOR_URL = "tkavna123"
        CI_PROJECT_PATH="spring-sample"
        APP_NAME="spring"
    }
    tools {
        git 'Default'
        jdk 'jdk'
        maven 'maven'
    }
      stages {
        stage('build maven') {
            steps {
                sh 'ls -al'
                sh 'maven package'
            }
        }
        stage('build kaniko') {
            steps {//docker를 대체하여 kaniko 컨테이너를 사용하여 harbor에 push
                    sh '/kaniko/executor --context ./ --dockerfile ./Dockerfile --destination $HARBOR_URL/$CI_PROJECT_PATH/$APP_NAME:${BUILD_NUMBER}'
            }
        }
        stage('push gitlab argo') {
            steps { // 미리 git에 연결된 ssh key 넣어둔 custom image를 사용하여 deploy 업데이트 
                git branch: 'main', credentialsId: 'macbook', url: 'https://github.com/sRrAiN98/spring_boot_test_helm.git'{
                    sh'''
                    git log | sed -n 5p > log.txt
                    LOG=`cat log.txt`
                    TAG=${BUILD_NUMBER} yq -i e '.image.tag = env(TAG)' values.yaml
                    git add values.yaml && git commit -m "$LOG" && git push origin helm
                    '''
                    // VALUES 파일 tag을 yq명령어로 수정하여 git commit & push 
                }
            }
        }
    }
}
