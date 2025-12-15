#!/bin/bash

# Get all PVCs in the cluster
pvc_list=$(kubectl get pvc --all-namespaces -o jsonpath='{range .items[*]}{.metadata.namespace}/{.metadata.name}{"\n"}{end}')

# Iterate over each PVC and annotate it
while IFS= read -r pvc; do
    namespace=$(echo "$pvc" | cut -d '/' -f 1)
    name=$(echo "$pvc" | cut -d '/' -f 2)
    
    # Annotate the PVC with a custom annotation
    kubectl annotate pvc "$name" -n "$namespace" reclaimspace.csiaddons.openshift.io/schedule=@hourly
done <<< "$pvc_list"
