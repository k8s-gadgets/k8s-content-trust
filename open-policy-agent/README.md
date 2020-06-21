# Install OPA


## Prerequisites
### Start minikube with the validations
```
minikube start --extra-config=apiserver.enable-admission-plugins=MutatingAdmissionWebhook,ValidatingAdmissionWebhook
```

## Step by step installation guide

### 1. Preparation (create certificates)
Communication between Kubernetes and OPA must be secured using TLS.  
This script creates the necessary certificates.
```bash
bash generateCerts.sh
```

During the guide to create a notary k8s deployment the script `generateCerts.sh` was executed.  
Copy following certificate from the `notary-k8s/helm/certs` folder to the `helm/opa/certs` folder:
- root-ca.crt


### 2. Deploy OPA 

1. create the namespace if it doesn't already exist
```bash
kubectl create namespace opa
```

2. Label the namespaces excluded from validations:
```bash
kubectl label ns kube-system openpolicyagent.org/webhook=ignore
kubectl label ns opa openpolicyagent.org/webhook=ignore
kubectl label ns notary openpolicyagent.org/webhook=ignore
```

3. Deploy Helm Chart
```bash
# switch to namespace opa
helm upgrade --install opa opa
```

### 3. Optional: Monitor validation logs

```bash
kubectl logs -n opa -f opa-deploy-<...> opa
```

### 4. Deinstall: **WARNING!**
The webhook is currently configured for all `CREATE` and `UPDATE` operations.  
When OPA is deinstalled via Helm the webhooks will **NOT** be deinstalled due to the installation via Helm hook.  
This is necessary to make sure they are registered after the OPA deployment.
To not destroy your cluster the wehooks should be deinstalled manually before the `helm uninstall` command.  
When the webhooks are not deleted manually the kubelet will not be able to update its status and the node status will change to `notReady`.

## Limitations
- the policy configmaps must be installed before the opa-deployment; otherwise it will not start
- the webhook must be installed after the opa-deployment; otherwise there will be a authentication error
