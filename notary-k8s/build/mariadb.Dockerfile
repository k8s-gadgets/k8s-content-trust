FROM mariadb:10.3.22

ARG NOTARYPKG

COPY --from=notary-binary /go/src/${NOTARYPKG}/notarysql/mysql-initdb.d /docker-entrypoint-initdb.d



