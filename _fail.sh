#/bin/bash -x

# Load .env file
export $(grep -v '^#' .env | xargs)

# Build the docker file. Depending on the target github repo and yarn.lock
# generated on the local system, we may see a failure.
echo '----- Docker Build -----'
set +x
docker build ./$GH_REPO -f Dockerfile --no-cache -t fail