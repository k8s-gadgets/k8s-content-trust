#!/bin/bash

kubectl apply -f 1-pod-latest.yml
kubectl apply -f 2-pod-tag1.yml
kubectl apply -f 3-pod-tag2.yml
kubectl apply -f 4-pod-sha1.yml
kubectl apply -f 5-pod-sha2.yml
kubectl apply -f 6-pod-latest-tag1.yml
kubectl apply -f 7-pod-latest-tag2.yml
kubectl apply -f 8-pod-latest-sha1.yml
kubectl apply -f 9-pod-latest-sha2.yml
kubectl apply -f 10-pod-tag1-sha1.yml
kubectl apply -f 11-pod-tag1-sha2.yml
kubectl apply -f 12-pod-tag2-sha1.yml
kubectl apply -f 13-pod-tag2-sha2.yml
kubectl apply -f 14-pod-tag1-sha1.yml
kubectl apply -f 15-pod-tag1-tag2.yml
kubectl apply -f 16-pod-tag2-tag2.yml
kubectl apply -f 17-pod-sha1-sha1.yml
kubectl apply -f 18-pod-sha1-sha2.yml
kubectl apply -f 19-pod-sha2-sha2.yml
kubectl apply -f 20-pod-latest-tag1-sha1.yml
kubectl apply -f 21-pod-latest-tag1-sha2.yml
kubectl apply -f 22-pod-latest-tag2-sha1.yml
kubectl apply -f 23-pod-latest-tag2-sha2.yml



