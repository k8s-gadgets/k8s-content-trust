FROM alpine:3.12.0

ARG NOTARYPKG

WORKDIR /etc/notary

COPY --from=notary-binary /go/src/${NOTARYPKG}/migrations /etc/notary/migrations

RUN apk add --no-cache curl \
    && curl -LO https://github.com/golang-migrate/migrate/releases/download/v4.10.0/migrate.linux-amd64.tar.gz \
    && tar -xzvf migrate.linux-amd64.tar.gz \
    && mv migrate.linux-amd64 /bin/migrate \
    && rm migrate.linux-amd64.tar.gz

RUN addgroup --gid 10000 notary \
    && adduser \
    --disabled-password \
    --gecos "" \
    --ingroup notary \
    --no-create-home \
    --uid 10000 notary

USER notary

ENTRYPOINT ["/etc/notary/migrations/migrate.sh"]

