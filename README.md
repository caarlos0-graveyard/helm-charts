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

Finally install this chart:

```sh
helm install --namespace thanos --name thanos ./thanos -f values.yaml
```

You can then port-forward the services you want:

```sh
kubectl -n thanos port-forward svc/thanos-query-http 8080:10902
kubectl -n thanos port-forward svc/thanos-prometheus-operator-prometheus 9090:9090
# etc...
```

---

## TODO

- [x] servicemonitors for thanso components
- [ ] TLS
- [ ] service discovery across clusters
- [ ] dynamic prometheus replica label for deduplication
- [ ] recommended rules for thanos components
