FROM alpine:3.5

WORKDIR /usr/local/bin

RUN ["wget", "https://github.com/prometheus/prometheus/releases/download/v2.4.2/prometheus-2.4.2.linux-amd64.tar.gz"]

RUN ["tar" "zxvf" "prometheus-2.4.2.linux-amd64.tar.gz"]

ENTRYPOINT [/usr/local/bin/prometheus-2.4.2.linux-amd64/promethus]


