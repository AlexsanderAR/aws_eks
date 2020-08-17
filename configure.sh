#!/bin/bash

errorMessage() {
  echo "${1}"
  exit 1
}

installTerraform() {
  echo "Installing Terraform"
  wget https://releases.hashicorp.com/terraform/0.13.0/terraform_0.13.0_linux_amd64.zip
  unzip terraform_*.zip
  /bin/rm terraform*.zip
  sudo mv terraform /usr/local/bin/
}

# instala terraform cli
which terraform > /dev/null || installTerraform

aws eks list-clusters 1> /dev/null 2> /dev/null || errorMessage "AWS profile not configured or with no EKS access"

# inicializa terraform plans
terraform init
for workspace in dev hlg prd ; do
  if [ ! -d terraform.tfstate.d/${workspace} ] ; then
    terraform workspace new ${workspace}
  fi
done
