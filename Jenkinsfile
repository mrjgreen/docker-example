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
    steps {
      sh '''make ci-build'''
    }
  }
}

stage('Waiting for approval') {
    input "Deploy to Production?"
}

node {
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
