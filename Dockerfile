ARG GOVERSION=1.21.5

FROM golang:${GOVERSION}-alpine AS build

WORKDIR /go/src/cs-cloudflare-worker-bouncer

RUN apk add --update --no-cache make git
COPY . .

RUN make build

FROM alpine:latest
COPY --from=build /go/src/cs-cloudflare-worker-bouncer/crowdsec-cloudflare-worker-bouncer /usr/local/bin/crowdsec-cloudflare-worker-bouncer
COPY --from=build /go/src/cs-cloudflare-worker-bouncer/config/crowdsec-cloudflare-worker-bouncer.yaml /etc/crowdsec/bouncers/crowdsec-cloudflare-worker-bouncer.yaml

ENTRYPOINT ["/usr/local/bin/crowdsec-cloudflare-worker-bouncer", "-c", "/etc/crowdsec/bouncers/crowdsec-cloudflare-worker-bouncer.yaml"]