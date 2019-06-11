# thanos helm chart

Helm chart that install and configure prometheus-operator and thanos.

## Goal

Make it as easy and reproducible as possible to setup a high-available and
durable prometheus on kubernetes using prometheus-operator and thanos.

## Getting started

#### 0. Helm repository

```sh
helm repo add carlos https://carlos-charts.storage.googleapis.com
helm repo update
```

#### 1. Namespace

```sh
kubectl create namespace thanos
```

#### 2. Storage config

You'll need a thanos storage config yaml file, as per
[documentation](https://thanos.io/storage.md/).

Then craete a `thanos-storage-config.yaml` file based on the provided
`thanos-storage-config.yaml.example`.

#### 3. TLS (optional)

```sh
certstrap init --common-name "My Root CA"
certstrap request-cert --domain example.com
certstrap sign --CA "My Root CA" example.com

certstrap request-cert --ip 127.0.0.1
certstrap sign --CA "My Root CA" 127.0.0.1
```

#### 4. Values file

Create a `values.yaml` file based on the provided `values.yaml.example`.
You can check all option available at `./thanos/values.yaml`, as well as
on the official `prometheus-operator` and `grafana` Helm charts.

#### 5. Install

```sh
helm install --namespace thanos --name thanos carlos/thanos -f values.yaml \
  --set-file objectStore=thanos-storage-config.yaml
```

##### 5.1 Upgrade when needed

```sh
helm upgrade --namespace thanos thanos carlos/thanos -f values.yaml \
  --set-file objectStore=thanos-storage-config.yaml
```

##### 5.2 If using TLS

Run the commands above with those additional flags:

```sh
  --set-file tls.server.crt=out/example.com.crt \
  --set-file tls.server.key=out/example.com.key \
  --set-file tls.client.crt=out/127.0.0.1.crt \
  --set-file tls.client.key=out/127.0.0.1.key
```

#### 6. Port-forward services

You can then port-forward the services you want:

```sh
kubectl -n thanos port-forward svc/thanos-query-http 8080:10902
kubectl -n thanos port-forward svc/thanos-prometheus-operator-prometheus 9090:9090
kubectl -n thanos port-forward svc/thanos-grafana 3000:80
# etc...
```

---

## TODO

- [x] remove peering options (deprecated on thanos 0.4.0+)
- [x] remove some not very useful options, leave sane defaults
- [x] servicemonitors for thanos components
- [ ] TLS
  - [ ] improve config
- [x] service discovery inside the cluster
- [ ] service discovery across clusters
- [ ] dynamic prometheus replica label for deduplication
- [x] recommended rules for thanos components
- [x] recommended dashboards for thanos components
- [x] thanos as datasource in grafana
- [x] objectstore config as file
- [ ] ingresses?
- [x] repo/releases
