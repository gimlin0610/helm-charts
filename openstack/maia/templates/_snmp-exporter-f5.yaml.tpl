f5:
  walk:
  - 1.3.6.1.4.1.3375.2.1.1.2.20.14
  - 1.3.6.1.4.1.3375.2.2.10.2.3.1.12
  metrics:
  - name: sysGlobalHostCpuUser5s
    oid: 1.3.6.1.4.1.3375.2.1.1.2.20.14
    type: gauge
  - name: ltmVirtualServStatClientCurConns
    oid: 1.3.6.1.4.1.3375.2.2.10.2.3.1.12
    type: gauge
    indexes:
    - labelname: ltmVirtualServStatName
      type: OctetString
