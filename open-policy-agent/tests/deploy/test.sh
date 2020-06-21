#!/bin/bash

kubectl apply -f 1-deploy-latest.yml
kubectl apply -f 2-deploy-tag1.yml
kubectl apply -f 3-deploy-tag2.yml
kubectl apply -f 4-deploy-sha1.yml
kubectl apply -f 5-deploy-sha2.yml
kubectl apply -f 6-deploy-latest-tag1.yml
kubectl apply -f 7-deploy-latest-tag2.yml
kubectl apply -f 8-deploy-latest-sha1.yml
kubectl apply -f 9-deploy-latest-sha2.yml
kubectl apply -f 10-deploy-tag1-sha1.yml
kubectl apply -f 11-deploy-tag1-sha2.yml
kubectl apply -f 12-deploy-tag2-sha1.yml
kubectl apply -f 13-deploy-tag2-sha2.yml
kubectl apply -f 14-deploy-tag1-sha1.yml
kubectl apply -f 15-deploy-tag1-tag2.yml
kubectl apply -f 16-deploy-tag2-tag2.yml
kubectl apply -f 17-deploy-sha1-sha1.yml
kubectl apply -f 18-deploy-sha1-sha2.yml
kubectl apply -f 19-deploy-sha2-sha2.yml
kubectl apply -f 20-deploy-latest-tag1-sha1.yml
kubectl apply -f 21-deploy-latest-tag1-sha2.yml
kubectl apply -f 22-deploy-latest-tag2-sha1.yml
kubectl apply -f 23-deploy-latest-tag2-sha2.yml



