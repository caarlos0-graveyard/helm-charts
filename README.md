# thanos helm chart

Helm chart that install and configure prometheus-operator and thanos.

## Goal

Make it as easy and reproducible as possible to setup a high-available and
durable prometheus on kubernetes using prometheus-operator and thanos.

## Getting started

#### 1. Namespace

```sh
kubectl create namespace thanos
```

#### 2. Storage config

You'll need a thanos storage config yaml file, as per
[documentation](https://thanos.io/storage.md/).

Then craete a `thanos-storage-config.yaml` file based on the provided
`thanos-storage-config.yaml.example`.

#### 3. Values file

Create a `values.yaml` file based on the provided `values.yaml.example`.
You can check all option available at `./thanos/values.yaml`, as well as
on the official `prometheus-operator` and `grafana` Helm charts.

#### 4. Install

```sh
helm install --namespace thanos --name thanos ./thanos -f values.yaml \
  --set-file objectStore=thanos-storage-config.yaml
```

##### 4.1 Upgrade when needed

```sh
helm upgrade --namespace thanos thanos ./thanos -f values.yaml \
  --set-file objectStore=thanos-storage-config.yaml
```

#### 5. Port-forward services

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
- [x] objectstore config as file
- [ ] ingresses?
