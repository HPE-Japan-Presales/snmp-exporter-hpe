[English](README_en.md)
# Prometheus SNMP Exporter for HPE Products

HPE製品に特化した設定済みのSNMP Exporterです。SNMP exporterの設定ファイルを作成するgeneratorでsnmp.ymlを作成する必要はありません。 このレポジトリに含まれているsnmp設定はHPE SIMのMib kitがベースとなっています。  

|  HPE SIM Version  |  MIB Kit Version  |
| :---: | :---: |
|  HPE SIM 7.6 Hotfix Oct-2020  |  [11.50](https://support.hpe.com/hpsc/swd/public/detail?swItemId=MTX-0741569cd81544c78f02136736)  |
|  HPE SIM 7.6 Limited Release 5  |  [11.40](https://support.hpe.com/hpsc/swd/public/detail?swItemId=MTX-aaf94a5dd38d42dda86fc083d8)  |
|  HPE SIM 7.6 Hotfix Oct-2019  |  [11.35](https://support.hpe.com/hpsc/swd/public/detail?swItemId=MTX-53293d026fb147958b223069b6)  |
|  HPE SIM 7.6 Limited Release 4  |  [11.30](https://support.hpe.com/hpsc/swd/public/detail?swItemId=MTX-c06c7ce759924d38a33b7023bf)  |

HPE SIMに関する詳細情報は[こちら](https://support.hpe.com/hpesc/public/docDisplay?docId=emr_na-c04272529)  
SNMP-Exporterに関する詳細情報は[こちら](https://github.com/prometheus/snmp_exporter)  
収集できるサンプルデータは[こちら](docs/sample_output_data.txt)

## Docker イメージ
[Dockerhub](https://hub.docker.com/r/fideltak/snmp-exporter-hpe)からコンテナイメージを取得することが可能です。

## SNMPv3認証
SNMPv3の認証情報はデフォルトで以下のように記載され値ます。snmp.ymlの下部に記載されているので必要に応じて変更してください。

```
  auth:
    security_level: authPriv
    username: prometheus
    password: password
    auth_protocol: SHA
    priv_protocol: AES
    priv_password: password
```

SNMP v3ユーザーをiLO上に作ることを忘れないようにしてください。

## Kubernetes
Kubernetes用に[サンプルマニフェスト](k8s-sample.yml)を用意しています。  
注意: このマニフェストは*Ingress*リソースを含んでいます。もし、Ingressをそのまま使う場合はご使用のingressコントローラを指定するか、Ingressの部分を削除してください。 

snmp.ymlはサイズが大きのでConfigMapを使ってsnmp.ymlをPodに渡すことはできませんでした。そのため、snmp.ymlそのものを[コンテナイメージ](https://hub.docker.com/r/fideltak/snmp-exporter-hpe)に含ませています。

snmp-exporterのデプロイ観完了後、スクレイピングされたデータを見ることができるはずです。 TargetにはiLOのIPアドレスまたは名前解決可能なホスト名を指定してください。
![snmp-exporter-gui](./docs/exporter-sample01.png)

Prometheusにスクレイピングしたデータを保存するためには*prometheus.yml*を編集する必要があります。
本snmp-exporterのモジュール名はデフォルトで*hpe-sim*です。
snmp-exporterの設定に関する情報は[こちら](https://github.com/prometheus/snmp_exporter)で確認してください。

```
  prometheus.yml: |
    scrape_configs:
    - job_name: snmp_hpe
      static_configs:
        - targets:
          - 192.168.2.106
          - 192.168.2.107
          - 192.168.2.108
      metrics_path: /snmp
      params:
        module: [hpe-sim]
      relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: snmp-exporter-hpe:9116
```

Prometheusに登録後、Exporterのヘルス状態がヘルシーになっているか確認してください。

![prometheus-targets](./docs/prometheus-target01.png)
