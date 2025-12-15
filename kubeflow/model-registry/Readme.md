# Inference API call example

From a terminal, you can use the following command to make a prediction request to the model registry predictor:

```curl -k -v -H "Content-Type: application/json" <http://sklearn-test-registry-predictor.namespace.svc.cluster.local/v1/models/sklearn-test-registry:predict> -d @./iris-input.json```
this supose that you are in the same namespace as the predictor service.

from an external client, you can use the following command to make a prediction request to the model registry predictor:
curl -k -v -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" <https://serving.kubefrog.ai/namespace/sklearn-test-registry/v1/models/sklearn-test-registry:predict> -d @./iris-input.json
TOKEN can be obtained like so:
kubectl create token default-editor -n namespace --audience istio-ingressgateway --duration 1h
