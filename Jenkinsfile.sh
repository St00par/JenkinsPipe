pipeline { 
    agent any
    options {
        skipStagesAfterUnstable()
    }
    stages {
        stage('Build') { 
            agent { label 'agent1' }
            steps { 
                echo '--------------- BUILD ---------------'
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/qasbirchall/java-hello-world']]])
                sh 'javac HelloWorld.java'
                sh 'jar cvfe HelloWorld.jar HelloWorld *.class' 
                archiveArtifacts artifacts: 'HelloWorld.jar', followSymlinks: false, onlyIfSuccessful: true
                echo '--------------- BUILD ---------------'
            }
        }
        stage('Deploy') {
            agent { label '!agent1' }
            steps {
                echo '--------------- DEPLOY ---------------'
                sh 'java -jar $JENKINS_HOME/jobs/$JOB_NAME/builds/$BUILD_NUMBER/archive/HelloWorld.jar'
                echo '--------------- DEPLOY ---------------'
            }
        }
    }
}
