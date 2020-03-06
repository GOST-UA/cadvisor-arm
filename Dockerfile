FROM golang:stretch as builder

ARG CADVISOR_VERSION="0.36.0"

WORKDIR /temp

RUN go mod init temp
RUN go get -d -v github.com/google/cadvisor@"v$CADVISOR_VERSION"
RUN mkdir bin
RUN go build -v -o bin/cadvisor github.com/google/cadvisor

FROM cyphernode/alpine-glibc-base:v3.11.0_2.29-0

COPY --from=builder /temp/bin/cadvisor /usr/bin/cadvisor

EXPOSE 8080

ENTRYPOINT ["/usr/bin/cadvisor", "-logtostderr"]
