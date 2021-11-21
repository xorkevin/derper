FROM golang:alpine3.14 as builder

# https://tailscale.com/kb/1118/custom-derp-servers/
RUN go install tailscale.com/cmd/derper@latest

FROM alpine:3
MAINTAINER xorkevin <kevin@xorkevin.com>
WORKDIR /home/derper

RUN apk add --no-cache ca-certificates tzdata

COPY --from=builder /go/bin/derper .

VOLUME /var/lib/derper
EXPOSE 8080
EXPOSE 3478/udp

ENTRYPOINT ["/home/derper/derper"]
CMD ["-c", "/var/lib/derper/data/derper.key", "-a", ":8080", "--stun"]
