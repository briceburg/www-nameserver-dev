FROM golang:1.10.3 as builder

WORKDIR /go/src/gist.githubusercontent.com/briceburg/www-nameserver-dev

# fetch source
# (typically) COPY . .
RUN curl -sL -o main.go https://gist.githubusercontent.com/briceburg/77a43440a87e305db4b872429c1cf256/raw

# Do the compile thingy thing
RUN go get &&\
    curl -sL -o /usr/local/bin/dep https://github.com/golang/dep/releases/download/v0.4.1/dep-linux-amd64 && \
    chmod +x /usr/local/bin/dep && { dep ensure || true ; } && { go get . || true ; }

RUN CGO_ENABLED=0 GOOS=linux go build


FROM scratch
COPY --from=builder /go/src/gist.githubusercontent.com/briceburg/www-nameserver-dev/www-nameserver-dev /main
ENTRYPOINT ["/main"]
