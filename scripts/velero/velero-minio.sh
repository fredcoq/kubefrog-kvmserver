#! /bin/sh
velero install \
    --image velero/velero:v1.9.5 \
    --provider aws \
    --plugins velero/velero-plugin-for-aws:v1.6.0,velero/velero-plugin-for-csi:v0.3.0 \
    --features=EnableCSI \
    --bucket velero \
    --secret-file ./credentials-velero \
    --use-volume-snapshots=true \
    --backup-location-config region=minio,s3ForcePathStyle="true",s3Url=http://192.168.0.200:9000 
