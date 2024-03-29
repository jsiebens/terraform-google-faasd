#! /bin/bash

curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
sudo bash add-google-cloud-ops-agent-repo.sh --also-install

mkdir -p /var/lib/faasd/secrets/
echo ${basic_auth_user} > /var/lib/faasd/secrets/basic-auth-user
echo ${basic_auth_password} > /var/lib/faasd/secrets/basic-auth-password

export FAASD_DOMAIN=${domain}
export LETSENCRYPT_EMAIL=${email}

curl -sfL https://raw.githubusercontent.com/openfaas/faasd/master/hack/install.sh | bash -s -