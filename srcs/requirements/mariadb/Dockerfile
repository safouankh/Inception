FROM debian:12

RUN apt-get update -y && apt-get install mariadb-server -y

COPY ./tools/script.sh /script.sh
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

RUN chmod 777 /script.sh

ENTRYPOINT [ "/script.sh" ]