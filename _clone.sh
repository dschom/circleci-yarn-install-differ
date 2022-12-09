#/bin/bash 

export $(grep -v '^#' .env | xargs)

echo '------ Setup Up -------'
# Clone the repo
git clone git@github.com:$GH_USER/$GH_REPO.git
git checkout $GH_BRANCH
echo '\n\n'