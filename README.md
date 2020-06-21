# Ensure Content Trust on Kubernetes using Notary and Open Policy Agent


<img src="/img/containership-head.png" />


This repository provides all components you require to install OPA and Notary on a Kubernetes Cluster. The middle-component Notary-Wrapper allows both CNCF-Solutions to communicate with each other, making it easy for OPA to verify if container images in a deployment request have existing trust data in Notary. 

*** For a detailed guide check out our [Blogpost on Medium](https://medium.com/@siegert.maximilian/ensure-content-trust-on-kubernetes-using-notary-and-open-policy-agent-485ab3a9423c) *** 


## Requirements to reconstruct our installation
If you want to follow the installation process along with this blog you will require the following components:
A Kubernetes Cluster or Minikube with enabled admission-plugins:

You should have at least the following admission-plugins enabled: 

```MutatingAdmissionWebhook, ValidatingAdmissionWebhook``` 

If you decide to use Minikube you can start it as follows:

```minikube start --extra-config=apiserver.enable-admission-plugins=MutatingAdmissionWebhook,ValidatingAdmissionWebhook```

Next you require a private or public registry to push your images.

 
### Installation 
As we assume that you might already have Notary or OPA in use, all installation guides are added to the respective subdirectory of the components. You can always reuse your existing setup, as long as you are sure that: 
- OPA is on its latest stable version 
- You added your certificates to the installations (e.g. Notary-Wrapper requires the ```NOTARY_ROOT_CA``` to perform requests over a secured connection against a private Notary-Server)

Otherwise, you should start the installation in the following order:
1. The Notary installation -> [Install Notary](/notary-k8s)
2. The Notary-Wrapper that is permitted to lookup trust data in Notary -> [Install Notary-Wrapper](/notary-wrapper)
3. OPA as admission controller with registered Validating and/or Mutating Webhooks -> [Install OPA](/open-policy-agent)

