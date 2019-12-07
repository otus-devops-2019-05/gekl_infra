#!/bin/bash

packer validate -var-file=packer/variables.json.example packer/app.json
packer validate -var-file=packer/variables.json.example packer/db.json
ansible-lint ansible/playbooks/*.yml

mkdir ~/.ssh
touch ~/.ssh/appuser.pub
touch ~/.ssh/appuser.pub
for env in stage prod; do
    cd terraform/${env}
    terraform init -backend=false
    terraform validate -var-file=terraform.tfvars.example
    tflint --var-file=terraform.tfvars.example
    cd -
done;
