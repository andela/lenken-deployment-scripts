cd /var/app/lenken 
BUILD_COMMIT=$(curl http://metadata.google.internal/computeMetadata/v1/project/attributes/frontend_build_commit -H "Metadata-Flavor: Google")
sudo mkdir -p ~/.ssh
sudo cp /etc/.ssh/id_rsa ~/.ssh && sudo chmod 400 ~/.ssh/id_rsa

git pull origin
git checkout ${BUILD_COMMIT}
export ENV=production
sudo chmod 777 /var/app/lenken
sudo rm -b src/env.ts
sudo rm -b src/environments/environment_prod.ts
sudo curl http://metadata.google.internal/computeMetadata/v1/project/attributes/lenken_frontend_env_ts -H "Metadata-Flavor: Google" > src/env.ts 
sudo curl http://metadata.google.internal/computeMetadata/v1/project/attributes/lenken_frontend_env_prod -H "Metadata-Flavor: Google" > src/environments/environment.prod.ts
yarn install --ignore-engines
yarn build
node index.js