#/bin/bash 

export $(grep -v '^#' .env | xargs)

# remove anything left over previous run
echo '----- Cleaning Up -----'
rm -rf $GH_REPO
rm -rf local-state
rm -rf docker-state
rm -rf results
echo '\n\n'