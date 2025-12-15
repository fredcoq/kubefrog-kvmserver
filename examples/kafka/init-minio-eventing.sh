#! /bin/bash
mc cp -r ./mnist/1549315748 syno/mnist

mc admin config set syno notify_kafka:1 \
                    tls_skip_verify="off" \
                    queue_dir="" \
                    queue_limit="0" \
                    sasl="off" \
                    sasl_password="" \
                    sasl_username="" \
                    tls_client_auth="0"\
                    tls="off" \
                    client_tls_cert="" \
                    client_tls_key="" \
                    brokers="192.168.0.102:9094" \
                    topic="mnist" \
                    version=""

mc admin service restart syno

sleep 2


mc event add syno/mnist arn:minio:sqs::1:kafka -p --event put --suffix .png

mc admin service restart syno
