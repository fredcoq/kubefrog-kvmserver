# script that list the files in the current directory which name finish virtualservice.yaml
# and then use yq to extract the first item of the array of hosts
# and then use the host name to extract the prefix from it
# and then use the prefix to add a second host name finishing with ${prefix}.kubefrog.local


#! bin/bash

for file in $(ls -1 *virtualservice.yaml)
do
  echo "file: $file"
  prefix=$(yq  '.spec.hosts[0]' $file | cut -d'.' -f1)
  echo "prefix: $prefix"
  path=".spec.hosts[0]" host=$prefix".kubefrog.ai" yq  -i 'eval(strenv(path)) = strenv(host)' $file
  yq -i 'del(.spec.gateways)' $file
  yq -i '.spec.gateways[0] = "apps-network/apps-gateway-cloud"' $file
  # yq -i '.metadata.name += "-cloud"' $file 

done