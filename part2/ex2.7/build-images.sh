#!/bin/sh
#
# Build the three docker images.
#


start=$(pwd)

# frontend
git clone https://github.com/docker-hy/ml-kurkkumopo-frontend.git
cd ml-kurkkumopo-frontend
docker build -t ml-kurkkumopo-frontend .

# backend
cd ${start}
git clone https://github.com/docker-hy/ml-kurkkumopo-backend.git
cd ml-kurkkumopo-backend
docker build -t ml-kurkkumopo-backend .


# training
cd ${start}
git clone https://github.com/docker-hy/ml-kurkkumopo-training.git
cd ml-kurkkumopo-training
docker build -t ml-kurkkumopo-training .
