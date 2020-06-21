# FROM golang:1.14.2-alpine3.11
FROM scratch

COPY --from=notary-binary /user/group /user/passwd /etc/
COPY --from=notary-binary /go/bin/notary-signer /notary/notary-signer

USER notary:notary

EXPOSE 7899

ENTRYPOINT [ "/notary/notary-signer","-config=/notary/signer-config.json" ]
