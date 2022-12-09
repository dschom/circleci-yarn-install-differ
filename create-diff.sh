#/bin/bash 

set -x

# Load .env file
export $(grep -v '^#' .env | xargs)

# Clean out old files
./_clean.sh

# Grab target repo
./_clone.sh

# Local install
./_install.sh

# Create diff
./_diff.sh
