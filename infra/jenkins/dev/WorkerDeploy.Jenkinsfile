properties([parameters([string(name: 'WORKER_IMAGE_NAME', trim: true)])])

pipeline {
    agent {
        docker {
            label 'polybot_cicd_general'
            image '352708296901.dkr.ecr.us-east-1.amazonaws.com/shay-polybot-jenkins-agent:2'
            args  '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        APP_ENV = "dev"
    }

    parameters {
        string(name: 'WORKER_IMAGE_NAME')
    }

    stages {
        stage('Worker Deploy') {
            steps {
                withCredentials([
                    file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')
                ]) {
                    sh '''
                    K8S_CONFIGS=infra/k8s

                    # replace placeholders in YAML k8s files
                    bash common/replaceInFile.sh $K8S_CONFIGS/worker.yaml APP_ENV $APP_ENV
                    bash common/replaceInFile.sh $K8S_CONFIGS/worker.yaml WORKER_IMAGE $WORKER_IMAGE_NAME

                    # apply the configurations to k8s cluster
                    kubectl apply --kubeconfig ${KUBECONFIG} -f $K8S_CONFIGS/worker.yaml
                    '''
                }
            }
        }
    }
}