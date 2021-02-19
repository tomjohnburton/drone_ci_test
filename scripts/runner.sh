export $(cat /tmp/secrets)

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
