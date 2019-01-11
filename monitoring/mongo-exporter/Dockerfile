FROM golang:1.11.4 as builder

ENV STOREDIR $GOPATH/src/github.com/percona
RUN mkdir -p $STOREDIR && cd $STOREDIR/ && git clone "https://github.com/percona/mongodb_exporter"
WORKDIR $STOREDIR/mongodb_exporter
RUN  CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o exporter.bin . && cp exporter.bin /

FROM scratch
COPY --from=builder /exporter.bin /exporter.bin
EXPOSE 9216
ENTRYPOINT [ "/exporter.bin" ]
