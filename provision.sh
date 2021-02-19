sudo apt-get update

sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get -y install docker-ce docker-ce-cli containerd.io

export $(cat /tmp/secrets)

sudo docker run \
  --volume=/var/lib/drone:/data \
  --env=DRONE_GITHUB_CLIENT_ID="$DRONE_GITHUB_CLIENT_ID" \
  --env=DRONE_GITHUB_CLIENT_SECRET="$DRONE_GITHUB_CLIENT_SECRET" \
  --env=DRONE_RPC_SECRET="$DRONE_RPC_SECRET" \
  --env=DRONE_SERVER_HOST="$DRONE_SERVER_HOST" \
  --env=DRONE_SERVER_PROTO="$DRONE_SERVER_PROTO" \
  --publish=80:80 \
  --publish=443:443 \
  --restart=always \
  --detach=true \
  --name=drone \
  drone/drone:1

sudo docker run -d \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --env DRONE_RPC_SECRET="$DRONE_RPC_SECRET" \
  --env DRONE_RPC_HOST="$DRONE_SERVER_HOST" \
  --env DRONE_RPC_PROTO="$DRONE_SERVER_PROTO" \
  --env DRONE_RUNNER_CAPACITY=2 \
  --env DRONE_RUNNER_NAME=drone-"$(date +%s)" \
  -p 3000:3000 \
  --restart always \
  --name runner \
  drone/drone-runner-docker:1
