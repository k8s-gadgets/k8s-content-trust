# notary-wrapper - an extension to communicate with a notary-server

The code can be found in this repo: https://github.com/k8s-gadgets/notary-wrapper  
**this code it is not production ready!**

The notary-wrapper is a small container image with minimum capabilities that uses only the necessary commands from the notary-cli to provide a REST-interface.  
It allows you to:
- Get digests for signed images from a notary-server and 
- Validate if an image has been signed

## Build and installation
The image of the wrapper can be built with the configurations provided in the repo at the top. If you want to build a stand-alone please consider that you need to add the certs to this image.

### Basic environment parameters
| Parameter                                   | Description                               | Default                                    |
| ------------------------------------------  | ----------------------------------------  | -------------------------------------------|
| `NOTARY_PORT`                               | port for notary-wrapper                   | `4445`                                     |
| `NOTARY_CERT_PATH`                          | path for certificate folders              | `/etc/certs/notary`                        |
| `NOTARY_ROOT_CA`                            | name of root-ca's                         | `root-ca.crt`                              |
| `NOTARY_CLI_PATH`                           | path for notary cli                       | `/notary/notary`                           |


### Required certificates for communication
- two certificates are necessary (must be mounted via secret):
  - notary-wrapper cert and key for serving https
- optional:
  - root-ca.crt to be able to communicate with notary-server (optional)
  - root-ca.crt:
    - ```NOTARY_CERT_PATH``` = "/etc/certs/notary" (defult)
    - mount the cert for each notary in different folder:
    - ```NOTARY_ROOT_CA``` = root-ca.cert  (same name for all root-ca's; in different folders)
    - naming convention folders:
      - name of service: ```notary-server-svc.notary.svc``` 
      - name of folder: ```notary-server-svc:4443```


## Step by step installation guide
### 1. Add the notary-wrapper image to your private registry
Go to the `build/` folder edit the registry parameter and the tags and run `bash build.sh`

### 2. Create the notary-wrapper deployment
#### 2.a Preparation
During the guide to create a notary k8s deployment the script `generateCerts.sh` was executed.  
In this script the certificates for the notary-wrapper were also created.  
Copy following certificates from the `notary-k8s/helm/certs` folder to the `helm/notary-wrapper/certs` folder:
- notary-wrapper.crt
- notary-wrapper.key
- root-ca.crt

#### 2.b Deploy the notary-wrapper chart
```bash
  kubectl create namespace opa
  # switch to namespace opa
  helm install notary-wrapper notary-wrapper
```

#### 2.c Test the notary-wrapper installation

Add following line to /etc/hosts:
```bash
127.0.0.1	    notary-wrapper-svc
```

On your local command line:

```bash
kubectl port-forward notary-wrapper-deploy-<...> 4445:4445
```

Curl checksum for **one tag** of one image:
```bash
curl -X POST https://notary-wrapper-svc:4445/list -H "Content-Type: application/json" -d '{"GUN":"<your-registry>/nginx", "Tag":"<tag>", "notaryServer":"notary-server-svc.notary.svc:4443"}' --cacert $HOME/.docker/tls/notary-server-svc:4443/root-ca.crt
```
Curl checksum for **all tags** of one image:
```bash
curl -X POST https://notary-wrapper-svc:4445/list -H "Content-Type: application/json" -d '{"GUN":"<your-registry>/nginx", "Tag":"", "notaryServer":"notary-server-svc.notary.svc:4443"}' --cacert $HOME/.docker/tls/notary-server-svc:4443/root-ca.crt
```

-----------
Example:
```bash
curl -X POST https://notary-wrapper-svc:4445/list -H "Content-Type: application/json" -d '{"GUN":"docker.io/dgeiger/nginx", "Tag":"", "notaryServer":"notary-server-svc.notary.svc:4443"}' --cacert $HOME/.docker/tls/notary-server-svc:4443/root-ca.crt
[{"Name":"1.15","Digest":"e770165fef9e36b990882a4083d8ccf5e29e469a8609bb6b2e3b47d9510e2c8d","Size":"948","Role":"targets"}]
```
-----------

For further examples have a look at the notary-wrapper repo (link on top)