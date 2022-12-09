# /bin/bash -x

# Load .env file
export $(grep -v '^#' .env | xargs)

# Blow away the lock file (if there is one), and install fresh.
echo '----- Fresh Install -----'
cd $GH_REPO
rm yarn.lock
touch yarn.lock
yarn install
cd ..
echo '\n\n'
