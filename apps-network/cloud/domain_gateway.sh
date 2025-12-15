# script that list the files in the current directory which name finish virtualservice.yaml
# and then use yq to extract the first item of the array of hosts
# and then use the host name to extract the prefix from it
# and then use the prefix to add a second host name finishing with ${prefix}.kubefrog.local


#! bin/bash

file=apps-gateway.yaml
for prefix in $(yq '.spec.servers[0].hosts[]' $file | cut -d'.' -f1)
do
  echo "prefix: $prefix"
  path=".spec.servers[0].hosts" host=$prefix".192.168.0.100.nip.io" yq  -i 'eval(strenv(path)) += strenv(host)' $file
  path=".spec.servers[1].hosts" host=$prefix".192.168.0.100.nip.io" yq  -i 'eval(strenv(path)) += strenv(host)' $file
done
