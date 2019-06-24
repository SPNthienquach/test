pipeline {
    agent {
        dockerfile true
    } 

    stages {
        stage('Example') {
            steps {
                echo 'Hello world'
                sh 'echo $myCustomEnvVar'
            }
        }
    }
}
