# Build new image and push to ACR.
WEB_IMAGE_NAME="${ACR_LOGINSERVER}/azure-vote-front:kube${BUILD_NUMBER}"
docker build -t $WEB_IMAGE_NAME ./azure-vote
docker login ${ACR_LOGINSERVER} -u ${ACR_ID} -p ${ACR_PASSWORD}
docker push $WEB_IMAGE_NAME

# Update kubernetes deployment with new image.
WEB_IMAGE_NAME="${ACR_LOGINSERVER}/azure-vote-front:kube${BUILD_NUMBER}"
kubectl set image deployment/azure-vote-front azure-vote-front=$WEB_IMAGE_NAME --kubeconfig /var/lib/jenkins/config



##### http://api.hiclass.net #######
# Build new image and push to ACR.
WEB_IMAGE_NAME="${ACR_LOGINSERVER}/hi-class-api:${BUILD_NUMBER}"
docker image build -t $WEB_IMAGE_NAME .
docker login ${ACR_LOGINSERVER} -u ${ACR_ID} -p ${ACR_PASSWORD}
docker push $WEB_IMAGE_NAME

# Deploy new Image & Replace buid number
sed -i "s/hiclass.azurecr.io\/hi-class-api.*/hiclass.azurecr.io\/hi-class-api:${BUILD_NUMBER}/g" hiclass-stage-api.yml
kubectl apply -f hiclass-stage-api.yml --namespace ingress-basic --kubeconfig /var/lib/jenkins/config
