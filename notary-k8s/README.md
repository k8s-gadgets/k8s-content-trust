# Notary on K8s
This is a directory that provides everything you need to install notary on kubernetes.


## Step by step installation guide 
### 1. Add the notary images to your private registry

First you need to build and push the notary images to your private registry.
This directory contains 4 builds:
1. The notary-signer 
2. The notary-server
3. The notary-db
4. The notary-wrapper --> Addition! (separate repository)

If you have notary already installed you need to build and install only the notary-wrapper.
Go to `notary-k8s/build` edit the registry parameter so that they fit your private registry and run `bash build.sh`

### 2. Create the notary deployment for Kubernetes
#### 2.a Preparation
Go to `notary-k8s/helm/notary`, open the `values.yaml` and edit:
1. Your `repository` name and optionally the credentials on the buttom of the script
2. A `passwordalias1Name` and name `passwordalias1Value`

Next you need to generate certificates for a secure communication with your signing service.
Go to:
 `notary-k8s/helm/notary`  and run `bash generateCerts.sh`

This will create a certs directory for your newly generated tls-certificates.

#### 2.b Deploy the notary chart
```bash
  kubectl create namespace notary
  # switch to namespace notary
  helm install notary notary
```

#### 2.c Test the notary installation
Now your pods should be running and you can sign images:  

Add following line to /etc/hosts
```
127.0.0.1	    notary-server-svc
```

On your local command line:

```bash
# first shell
docker pull nginx:latest

export DOCKER_CONTENT_TRUST_SERVER=https://notary-server-svc:4443
export DOCKER_CONTENT_TRUST=1

mkdir -p $HOME/.docker/tls/notary-server-svc:4443
cp <...>/helm/notary/certs/root-ca.crt $HOME/.docker/tls/notary-server-svc:4443/
```

```bash
# second shell
kubectl port-forward notary-server-deploy<...> 4443:4443
```

```bash
# first shell
docker tag nginx:latest <your-registry>/nginx:tag
docker push <your-registry>/nginx:tag
notary -s https://notary-server-svc:4443 list <your-registry>/nginx

# valid for hub.docker.io
notary -s https://notary-server-svc:4443 \
       --tlscacert $HOME/.docker/tls/notary-server-svc:4443/root-ca.crt \
       list docker.io/dgeiger/nginx
```
<span style="color:red">**Note: Docker pull (also includes build if image not locally available) for any unsigned images will not be possible anymore while content trust is activated!**</span>

