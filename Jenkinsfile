pipeline {
    options {
      skipDefaultCheckout(true)
      }
    environment {
        HARBOR_URL = "harbor.skdev.kro.kr"
        CI_PROJECT_PATH="muv-frontend"
        APP_NAME="webui"
    }
      stages {
        stage('build maven') {
            steps { // jdk15버전이상의 maven컨테이너를 사용하여 maven 빌드 
                container('maven') {
                    sh 'ls -al'
                    sh 'mvn package'
                }
            }
        }
        stage('build kaniko') {
            steps {//docker를 대체하여 kaniko 컨테이너를 사용하여 harbor에 push
                container('kaniko') { 
                    sh '/kaniko/executor --context ./ --dockerfile ./Dockerfile --destination $HARBOR_URL/$CI_PROJECT_PATH/$APP_NAME:${BUILD_NUMBER}'
                }
            }
        }
        stage('push gitlab argo') {
            steps { // 미리 git에 연결된 ssh key 넣어둔 custom image를 사용하여 deploy 업데이트 
              container('alpine') { //git clone 위치 확인 필요 (변경포인트), cd 폴더 진입 (변경포인트)
                    sh'''
                    git clone --branch helm git@gitlab.skdev.kro.kr:EVPark/muv-frontend-webui.git
                    ls -la
                    git log | sed -n 5p > muv-frontend-webui/log.txt
                    cd muv-frontend-webui 
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
