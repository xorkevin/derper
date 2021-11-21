FROM golang:alpine3.14 as builder
RUN apk add --no-cache ca-certificates tzdata

# https://tailscale.com/kb/1118/custom-derp-servers/
RUN go install tailscale.com/cmd/derper@main

FROM scratch
MAINTAINER xorkevin <kevin@xorkevin.com>
WORKDIR /home/derper

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /go/bin/derper .

VOLUME /var/lib/derper
EXPOSE 8080
EXPOSE 3478/udp

ENTRYPOINT ["/home/derper/derper"]
CMD ["-c", "/var/lib/derper/data/derper.key", "-a", ":8080", "--stun"]
