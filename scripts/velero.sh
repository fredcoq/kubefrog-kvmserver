#! /bin/bash
velero install \
    --provider aws \
    --plugins velero/velero-plugin-for-aws:v1.2.0,velero/velero-plugin-for-csi:v0.1.2 \
    --bucket velero \
    --use-restic  \
    --secret-file ./velero/credentials-velero \
    --use-volume-snapshots=true \
    --backup-location-config region=minio,s3ForcePathStyle="true",s3Url=http://192.168.0.200:9000 \
    --default-volumes-to-restic
