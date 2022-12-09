#/bin/bash -xe

export $(grep -v '^#' .env | xargs)

echo '------ Build Docker Image - Runs yarn install with checksums update ------'
docker build  -t checksum-test --build-arg BEHAVIOR=update --no-cache ./$GH_REPO -f Dockerfile
echo '\n\n'

echo '------ Copy Container State - Copying to ./docker-state ------'
docker run checksum-test tail -f /dev/null &
sleep 2
ID=$(docker container ls  | grep 'checksum-test' | awk '{print $1}')
docker cp $ID:$DOCKER_DIR ./docker-state
docker rm -f $ID
echo '\n\n'

echo '----- Produce Diff - Diff local-state & docker-state. Output file to ./results.diff -----'
mkdir -p results
diff -r $GH_REPO docker-state > results/main.diff;
cat results/main.diff