FROM golang:1.14.4-alpine3.12
RUN apk --update add sed git  gcc libc-dev

ARG NOTARY_BRANCH
ARG NOTARYPKG

RUN git clone -b $NOTARY_BRANCH https://${NOTARYPKG}.git /go/src/${NOTARYPKG}

WORKDIR /go/src/${NOTARYPKG}

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -tags "pkcs11 netgo" \
    -ldflags "-w -s -X ${NOTARYPKG}/version.GitCommit=`git rev-parse --short HEAD` -X ${NOTARYPKG}/version.NotaryVersion=`cat NOTARY_VERSION` -extldflags -static" -o /go/bin/notary-server ${NOTARYPKG}/cmd/notary-server 

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -tags "pkcs11 netgo" \
    -ldflags "-w -s -X ${NOTARYPKG}/version.GitCommit=`git rev-parse --short HEAD` -X ${NOTARYPKG}/version.NotaryVersion=`cat NOTARY_VERSION` -extldflags -static" -o /go/bin/notary-signer ${NOTARYPKG}/cmd/notary-signer 

RUN GOOS=linux GOARCH=amd64 go build -tags "pkcs11 netgo" \
    -ldflags "-w -s -X ${NOTARYPKG}/version.GitCommit=`git rev-parse --short HEAD` -X ${NOTARYPKG}/version.NotaryVersion=`cat NOTARY_VERSION` -extldflags '-static'" -o /go/bin/notary ${NOTARYPKG}/cmd/notary


## remove second '[' & ']' from file migrations.sh
RUN sed -i 's/\[//2' migrations/migrate.sh && sed -i 's/\]//2' migrations/migrate.sh

WORKDIR /go

RUN mkdir /user && \
    echo 'notary:x:10000:10000:notary:/:' > /user/passwd && \
    echo 'notary:x:10000:' > /user/group
