#/bin/bash -xe

export $(grep -v '^#' .env | xargs)

echo '------ Build Docker Image - Runs yarn install with checksums update ------'
docker build  -t checksum-test --build-arg BEHAVIOR=update --no-cache ./$GH_REPO -f Dockerfile
echo '\n\n'

echo '------ Copy Container State - Copying to ./docker-state ------'
docker run checksum-test tail -f /dev/null &
sleep 2
ID=$(docker container ls  | grep 'checksum-test' | awk '{print $1}')
mkdir -p results
docker cp $ID:$DOCKER_DIR/yarn.lock ./results/yarn.lock
docker rm -f $ID
echo `Lock file results/yarn.lock`
echo '\n\n'
