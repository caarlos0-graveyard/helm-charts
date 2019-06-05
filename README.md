# thanos helm chart

Helm chart that install and configure prometheus-operator and thanos.

## Goal

Make it as easy and reproducible as possible to setup a high-available and
durable prometheus on kubernetes using prometheus-operator and thanos.

## Getting started

```sh
kubectl create namespace thanos
```

You'll need a thanos storage config yaml file, as per
[documentation](https://thanos.io/storage.md/).

Then create a secret with it:

```sh
kubectl -n thanos create secret generic thanos-objstore-config --from-file=thanos.yaml=thanos-storage-config.yaml
```

> Check `thanos-storage-config.yaml.example` for an example of `thanos-storage-config.yaml`

To generate a self-signed PFX file (skip if you already have one):

```sh
openssl req -x509 -days 365 -newkey rsa:2048 -keyout cert.pem -out cert.pem
openssl pkcs12 -export -in cert.pem -inkey cert.pem -out cert.pfx


openssl genrsa -out server.key 2048
openssl req -new -x509 -sha256 -key server.key -out server.crt -days 3650
openssl req -new -sha256 -key server.key -out server.csr
openssl x509 -req -sha256 -in server.csr -signkey server.key -out server.crt -days 3650


certstrap init --common-name "mydomain.com"
```

Then generate the other needed files:

```sh
# public key
openssl pkcs12 -in cert.pfx -nocerts -nodes -out cert.key
# private key
openssl pkcs12 -in cert.pfx -clcerts -nokeys -out cert.cer
# certificate authority (CA)
openssl pkcs12 -in cert.pfx -cacerts -nokeys -chain -out cacerts.cer
```

Finally install this chart:

```sh
helm install --namespace thanos --name thanos ./thanos -f values.yaml \
  --set-file tls.cert=out/caarlos0.dev.crt \
  --set-file tls.key=out/caarlos0.dev.key
```

Or upgrade:

```sh
helm upgrade --namespace thanos thanos ./thanos -f values.yaml \
  --set-file tls.cert=out/caarlos0.dev.crt \
  --set-file tls.key=out/caarlos0.dev.key
```

> Check `values.yaml.example` for an example of `values.yaml`

You can then port-forward the services you want:

```sh
kubectl -n thanos port-forward svc/thanos-query-http 8080:10902
kubectl -n thanos port-forward svc/thanos-prometheus-operator-prometheus 9090:9090
# etc...
```

---

## TODO

- [x] servicemonitors for thanos components
- [ ] TLS
- [x] service discovery inside the cluster
- [ ] service discovery across clusters
- [ ] dynamic prometheus replica label for deduplication
- [x] recommended rules for thanos components
- [x] recommended dashboards for thanos components
- [x] thanos as datasource in grafana
