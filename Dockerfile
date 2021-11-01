FROM golang:alpine AS builder
WORKDIR /app
RUN apk --no-cache --no-progress add git \
    && go env -w GO111MODULE=on \
    && go env -w GOPROXY=https://goproxy.cn,direct \
    && git clone git://github.com/xiaoxinpro/WebStackGo.git \
    && cd WebStackGo \
    && export GIN_MODE=release \
    && go build -o WebStackGo main.go
FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/WebStackGo/WebStackGo /app/WebStackGo
COPY --from=builder /app/WebStackGo/json /app/json
COPY --from=builder /app/WebStackGo/public /app/public
COPY --from=builder /app/WebStackGo/views /app/views
#EXPOSE 2802
ENTRYPOINT ["/app/WebStackGo"]
