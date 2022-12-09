#/bin/bash

# Load .env file
export $(grep -v '^#' .env | xargs)

./_clean.sh
./_clone.sh
./_install.sh
./_makeyarnlock.sh