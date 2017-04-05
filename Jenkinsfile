pipeline {
  agent any
  stages {
    stage('Install') {
      steps {
        sh '''make ci-build'''
      }
    }
  }
}
