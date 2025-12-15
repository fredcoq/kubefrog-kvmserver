## Important guidelines for harbor setup
### Context: https exposed service (secure or insecured)

### Service connectivity:

Set the exposed URL to the proxy url set-up.
 If the service is exposed through a kuberntes ingress behind a loadbalancer it should be the URL used to contact the service : core.harbor.domain.com which resolve to the LB IP.

### Authentication:
In so far as the registry can be used for pod image pulling (kubelet or knative) or for image pushing the following tips are usefull :
authentication is required for the registry to be accessible. (Even if the rgistry is set as public)
- doker secret example for connection
this format is working well with kaniko :
auth secret chain in base64 format
"""
 {"auths":
    {"core.harbor.192.168.0.101.nip.io":
        {"username":"admin",
        "password":"Harbor12345",
        "email":"frederik.coquelet@gmail.com",
        "auth":"YWRtaW46SGFyYm9yMTIzNDU="
        }
    }
}
"""

- create secret containing ingress certificate and 