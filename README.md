# Yarn lock checksum mismatch
 
## Background
 
Some systems appear to experience faulty checksum in the yarn.lock file. See this thread for reports of such behavior.
 
https://github.com/yarnpkg/berry/issues/2399
 
This repo aims to demonstrate the problem, and provide boilerplate to quickly diagnose the issue.
 
## System Setup
The system that this is currently being tested on is as follows:
 
- Hardware: MacBook Pro (16-inch, 2021)
- OS: MacOS Monterey v12.6
- git: v2.38.1 
- node: v16.13.2 
- CI docker image: cimg/node:16.13
   - git: v2.33.0
   - node: v16.13.2
- Docker Version:
```
Client:
Cloud integration: v1.0.29
Version:           20.10.21
API version:       1.41
Go version:        go1.18.7
Git commit:        baeda1f
Built:             Tue Oct 25 18:01:18 2022
OS/Arch:           darwin/arm64
Context:           desktop-linux
Experimental:      true
 
Server: Docker Desktop 4.15.0 (93002)
Engine:
 Version:          20.10.21
 API version:      1.41 (minimum version 1.12)
 Go version:       go1.18.7
 Git commit:       3056208
 Built:            Tue Oct 25 17:59:41 2022
 OS/Arch:          linux/arm64
 Experimental:     false
containerd:
 Version:          1.6.10
 GitCommit:        770bd0108c32f3fb5c73ae1264f7e503fe7b2661
runc:
 Version:          1.1.4
 GitCommit:        v1.1.4-0-g5fd4c4d
docker-init:
 Version:          0.19.0
 GitCommit:        de40ad0
```
- Git Config Settings:
```
[core]
   repositoryformatversion = 0
   filemode = true
   bare = false
   logallrefupdates = true
   ignorecase = true
   precomposeunicode = true
```
_(Note: these are system defaults)_
 
## To produce failure
 
Run the `./create-failure.sh`, which does the following:
 
1. Runs a clean yarn install
2. Builds a docker image with both package and lockfile copied over.
3. Attempts a `yarn install`.
 
With these steps, on a system as described above, the `yarn install` will fail due to a checksum mismatch
 
## To Investigate Reason for Checksum Failure
 
Run `./create-diff.sh`, which does the following:
 
1. Runs a clean yarn install
2. Builds a docker image with both package and lockfile copied over.
3. This time it sets the YARN_CHECKSUM_BEHAVIOR to update so the install doesn't fail, and new checksums are produce.
4. The files from the docker container are then copied to docker-state.
5. The local repository files are copied to local-state.
6. A diff is run on the local-state and docker-state folders to determine where the issue lies. This is output, and stored in results/main.diff
 
## To simply generate a lock file matching the remote system

Run './create-lockfile.sh', which does the following:

1. Runs a clean yarn install
2. Builds a docker image with both package and lockfile copied over.
3. This time it sets the YARN_CHECKSUM_BEHAVIOR to update so the install doesn't fail, and new checksums are produce.
4. Copies the lockfile from the docker image to results/yarn.lock

## Forking This Repo
 
This repo is a great starting point for anyone trying to diagnose build discrepancies between a remote build (conducted with docker) and local build.
The code is designed around detecting issues with a `yarn install`, but it can easily be modified to support other repos, and probably other types of install / build processes.
Once forked, if you are just trying to diagnose `yarn install` issues, simply edit the .env file with desired settings to change the behavior. To diagnose a different install / build i.e. npm, pip, gems, etc, some modification of the scripts and Dockerfile will be needed.
 
## So what was the fix for the checksum mismatch?
 
Once I determined it was the result of new lines I found this bug: https://github.com/yarnpkg/berry/issues/4917.
 
It seemed similar, so I tried adding `RUN corepack enable` in the dockerfile and the issue was resolved. The converse, however, wasn't true. Disabling or enabling corepack on my local system prior to running either `create-failure.sh` or `create-diff.sh` had no effect.
 
Apparently this will be fixed soon, since the [PR](https://github.com/yarnpkg/berry/issues/4917) landed somewhat recently. Let's hope it does, and explicitly enabling corepack is no longer necessary.
