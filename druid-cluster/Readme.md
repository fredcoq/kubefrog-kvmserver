# Druid Operator Resources

This document provides an overview of the resources used by the Druid Operator.

## DruidCluster

The `DruidCluster` is a custom resource definition (CRD) that represents a Druid cluster. It defines the desired state for a Druid cluster, including the number of brokers, historicals, and middleManagers, as well as their resource requirements.

Example:

```yaml
apiVersion: druid.apache.org/v1alpha1
kind: DruidCluster
metadata:
  name: example-cluster
spec:
  replicas: 3
  commonConfig:
    image: apache/druid:0.21.1
    resources:
      requests:
        memory: "2Gi"
        cpu: "1"
      limits:
        memory: "4Gi"
        cpu: "2"
  broker:
    serviceType: LoadBalancer
  historical:
    volumeClaimTemplate:
      spec:
        accessModes: ["ReadWriteOnce"]
        resources:
          requests:
            storage: 10Gi
  middleManager:
    volumeClaimTemplate:
      spec:
        accessModes: ["ReadWriteOnce"]
        resources:
          requests:
            storage: 5Gi
