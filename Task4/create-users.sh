#!/bin/bash

# Создаем пользователей и TLS certificate
openssl genrsa -out vlad.key 2048
openssl req -new -key vlad.key -out vlad.csr -subj "/CN=vlad/O=developers"
openssl x509 -req -in vlad.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out vlad.crt -days 365

openssl genrsa -out bob.key 2048
openssl req -new -key bob.key -out bob.csr -subj "/CN=bob/O=security"
openssl x509 -req -in bob.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out bob.crt -days 365

# Добавляем пользователей в kubeconfig
kubectl config set-credentials vlad --client-certificate=vlad.crt --client-key=vlad.key
kubectl config set-credentials bob --client-certificate=bob.crt --client-key=bob.key

# Создаем контексты для пользователей
kubectl config set-context vlad-context --cluster=minikube --user=vlad
kubectl config set-context bob-context --cluster=minikube --user=bob

echo "Users vlad (developer) and bob (security) created "