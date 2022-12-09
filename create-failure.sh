#/bin/bash -x

# Load .env file
export $(grep -v '^#' .env | xargs)

# Clean exisitng state
./_clean.sh

# Grab target repo
./_clone.sh

# Install packages
./_install.sh

# Do docker build and see failure
./_fail.sh