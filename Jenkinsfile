node {
  stage('Clean Workspace') {
    deleteDir()
  }
}

node {
  stage('Checkout') {
    checkout scm
  }
}

node {
  stage('Build') {
    sh '''make ci-build'''
  }
}

stage('Waiting for approval') {
    input "Deploy to Production?"
}

node {
  stage('Publish') {
    sh '''make ci-publish'''
  }

  stage('Deploy') {
    sh '''make ci-deploy'''
  }
}
