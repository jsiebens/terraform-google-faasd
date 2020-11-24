#! /bin/bash

curl -sSO https://dl.google.com/cloudagents/add-logging-agent-repo.sh
bash add-logging-agent-repo.sh
apt-get update

apt-get install -y google-fluentd google-fluentd-catch-all-config-structured
service google-fluentd start

mkdir -p /var/lib/faasd/secrets/
echo ${gw_password} > /var/lib/faasd/secrets/basic-auth-password
echo admin > /var/lib/faasd/secrets/basic-auth-user

curl -sfL https://raw.githubusercontent.com/openfaas/faasd/master/hack/install.sh | sh -s -