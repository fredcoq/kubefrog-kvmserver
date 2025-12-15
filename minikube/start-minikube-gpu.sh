minikube start  --extra-config=apiserver.service-account-issuer=api \
                --extra-config=apiserver.service-account-signing-key-file=/var/lib/minikube/certs/sa.key \
                --extra-config=apiserver.service-account-api-audiences=api \
                --driver=none \
		--kubernetes-version=v1.20.3 \
                --apiserver-ips 127.0.0.1 \
                --apiserver-name localhost \
		--extra-config=kubelet.max-pods=200 \
		--container-runtime=cri-o \
		--network-plugin=cni \
		--extra-config=kubeadm.pod-network-cidr=10.0.0.0/22


chown -R $USER $HOME/.kube $HOME/.minikube

minikube addons enable metrics-server
minikube addons enable helm-tiller
minikube addons enable ingress
