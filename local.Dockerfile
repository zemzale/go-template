FROM golang:1.15-alpine

RUN apk update && apk add git make

WORKDIR /go/src/<project-path>

RUN go get github.com/githubnemo/CompileDaemon

COPY /. ./

EXPOSE 80/tcp

ENTRYPOINT CompileDaemon --build="make build" --command="./<bin-path> serve"
