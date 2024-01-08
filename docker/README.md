# cloudflare-worker-bouncer

This remediation component deploys Cloudflare Worker in front of a Cloudflare Zone/Website, which checks if incoming request's IP address/Country/AS is present in a KV store and takes necessary remedial actions. It also periodically updates the KV store with CrowdSec LAPI's decisions.

See the docs for [full details](https://docs.crowdsec.net/u/bouncers/cloudflare-workers/) on this bouncer.

### Build the Image

```bash
docker build -t cs-cloudflare-worker-bouncer .
```

### Initial Setup

Get your Cloudflare token as described [here](https://docs.crowdsec.net/u/bouncers/cloudflare-workers/#cloudflare-configuration).

```bash
docker run cs-cloudflare-worker-bouncer \
 -g <CLOUDFLARE_TOKEN1> <CLOUDFLARE_TOKEN2> > cfg.yaml # auto-generate cloudflare config for provided space separated tokens
 vi cfg.yaml # review config and set `crowdsec_lapi_key`
```

The `crowdsec_lapi_key` can be obtained by running the following:
```bash
sudo cscli bouncers add cloudflareworkerbouncer
```

The `crowdsec_lapi_url` must be accessible from the container.

### Run the bouncer

```bash
docker run \
  -v $PWD/cfg.yaml:/etc/crowdsec/bouncers/crowdsec-cloudflare-worker-bouncer.yaml \
  -p 2112:2112 \
  cs-cloudflare-worker-bouncer
```

### Cloudflare Cleanup

This deletes all the Cloudflare infrastructure which was created by the bouncer.

```bash
docker run cs-cloudflare-worker-bouncer -d
```

