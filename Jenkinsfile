pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh '''make ci-build'''
      }
    }
    stage('Publish') {
      steps {
        sh '''make ci-publish'''
      }
    }
    stage('Deploy') {
      steps {
        sh '''make ci-deploy'''
      }
    }
  }
}
