
def call(Map config) {
    pipeline {
        agent any

        options {
            timestamps()
            disableConcurrentBuilds()
        }

        environment {
            AWS_REGION = 'us-east-1'
            AWS_ACCOUNT_ID = '746491202405'
            ECR_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

            SERVICE_NAME = "${config.serviceName}"
            SERVICE_DIR = "${config.serviceDir}"
            ECR_REPOSITORY = "${config.ecrRepository}"

            IMAGE_NAME = "${ECR_REGISTRY}/${config.ecrRepository}"
            IMAGE_TAG = "${BUILD_NUMBER}"
            IMAGE = "${IMAGE_NAME}:${IMAGE_TAG}"

            DEPLOYMENT_FILE = "kubernetes/${config.deploymentFile}"
        }

        stages {
            stage('Build Image') {
                steps {
                    sh 'docker build -t "$IMAGE" "$SERVICE_DIR"'
                }
            }

            stage('Scan Image') {
                steps {
                    sh '''
                        trivy image \
                          --exit-code 1 \
                          --severity HIGH,CRITICAL \
                          "$IMAGE"
                    '''
                }
            }

            stage('Push Image') {
                steps {
                    sh '''
                        aws ecr get-login-password --region "$AWS_REGION" |
                        docker login \
                          --username AWS \
                          --password-stdin "$ECR_REGISTRY"

                        aws ecr describe-repositories \
                          --repository-names "$ECR_REPOSITORY" \
                          --region "$AWS_REGION" >/dev/null

                        docker push "$IMAGE"
                    '''
                }
            }

            stage('Delete Image Locally') {
                steps {
                    sh 'docker image rm "$IMAGE" || true'
                }
            }

            stage('Update Manifests') {
                steps {
                    sh '''
                        sed -i -E \
                          "s|image: .*|image: ${IMAGE}|" \
                          "$DEPLOYMENT_FILE"

                        grep -n 'image:' "$DEPLOYMENT_FILE"
                    '''
                }
            }

            stage('Push Manifests') {
                steps {
                    withCredentials([
                        gitUsernamePassword(
                            credentialsId: 'github-credentials',
                            gitToolName: 'Default'
                        )
                    ]) {
                        sh '''
                            git config user.name "Jenkins"
                            git config user.email "jenkins@localhost"

                            git add "$DEPLOYMENT_FILE"

                            if git diff --cached --quiet; then
                                echo "No manifest changes to commit."
                            else
                                git commit -m "Update ${SERVICE_NAME} image to ${IMAGE_TAG}"
                                git push origin HEAD:main
                            fi
                        '''
                    }
                }
            }
        }

        post {
            always {
                sh 'docker image rm "$IMAGE" 2>/dev/null || true'
            }
        }
    }
}
