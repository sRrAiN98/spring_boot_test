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
                    withCredentials([sshUserPrivateKey(credentialsId: 'macbook', keyFileVariable: 'FILE', passphraseVariable: 'KEY', usernameVariable: 'USER')]) {
                        sh 'git log | sed -n 5p > log.txt'
                        git branch: 'main', credentialsId: 'sRrAiN', url: 'https://github.com/sRrAiN98/spring_boot_test_helm.git'
                        sh'''
                        git config --global user.email "jenkins@example.com"
                        git config --global user.name "jenkins"
                        sed -i 's|tag: .*|tag: ${BUILD_NUMBER}|'  values.yaml
                        cat log.txt
                        LOG=`cat log.txt`
                        git add values.yaml && git commit -m "$LOG" 
                        git push origin main
                        git push https://${USER}:${KEY}@github.com/sRrAiN98/spring_boot_test_helm.git'
                        '''
                    }
                }
            }
        }
    }
}
