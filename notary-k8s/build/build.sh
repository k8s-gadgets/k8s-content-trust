#!/bin/bash

NOTARY_BRANCH=master
NOTARYPKG=github.com/theupdateframework/notary

REGISTRY=dgeiger
NOTARY_TAG=master

# build notary binaries
docker build \
    --build-arg NOTARY_BRANCH=$NOTARY_BRANCH \
    --build-arg NOTARYPKG=$NOTARYPKG \
    -f ./binaryNotary.Dockerfile \
    -t notary-binary .

# use local notary-client
# copy binary to local directory
echo 'copy the binary files to local...'
ID=$(docker create notary-binary)
rm /usr/local/bin/notary
docker cp $ID:/go/bin/notary /usr/local/bin/

# build notary images
docker build -t $REGISTRY/notary-signer:$NOTARY_TAG -f signer.Dockerfile .
docker build -t $REGISTRY/notary-server:$NOTARY_TAG -f server.Dockerfile .
docker build -t $REGISTRY/notary-migrate:$NOTARY_TAG --build-arg NOTARYPKG=$NOTARYPKG -f migrate.Dockerfile .
docker build -t $REGISTRY/notary-mariadb:$NOTARY_TAG --build-arg NOTARYPKG=$NOTARYPKG -f mariadb.Dockerfile .

# push notary images
docker push $REGISTRY/notary-signer:$NOTARY_TAG
docker push $REGISTRY/notary-server:$NOTARY_TAG
docker push $REGISTRY/notary-migrate:$NOTARY_TAG

# remove container and image
docker rm -f $ID
# docker rmi -f notary-binary
