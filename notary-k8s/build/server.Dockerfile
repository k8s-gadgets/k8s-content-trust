# FROM golang:1.14.2-alpine3.11
FROM scratch

COPY --from=notary-binary /user/group /user/passwd /etc/
COPY --from=notary-binary /go/bin/notary-server /notary/notary-server

USER notary:notary

EXPOSE 4443

ENTRYPOINT [ "/notary/notary-server","-config=/notary/server-config.json" ]
