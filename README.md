# Terraform automation experiments

Terraform experiments in creating VM's in AWS, Azure and Oracle OCI for registration in Portainer

## Create SSH Encryption Keys
```bash
ssh-keygen -t rsa -N "" -b 2048 -C portainer-ssh-key -f portainer-ssh-key
chmod 400 portainer-ssh-key
chmod 644 portainer-ssh-key.pub
```

### Remove ip known_hosts (tips)
ssh-keygen -R "[IP Address]" 

## Terraform commands
### Create VM commands
```bash
terraform init -reconfigure
#terraform init -upgrade 
terraform validate
terraform plan -out main.tfplan
terraform apply main.tfplan
```

### Destroy VM commands
```bash
terraform plan -destroy -out main.destroy.tfplan
terraform apply main.destroy.tfplan
```

### Show Terraform outputs
```bash
terraform output
```

### Activate Terraform logs
```bash
export TF_LOG="DEBUG"
export TF_LOG_PATH="tmp/terraform.log"
```

### Connect remote compute host
ssh -i portainer-ssh-key ubuntu@IP

## List Variables
```
variable base_name {}
variable region {}
variable username {}
variable private_ssh_key {
  default = "PATH_FOR_SSH_KEY/portainer-ssh-key"
}
variable public_ssh_key {
  default = "PATH_FOR_SSH_KEY/portainer-ssh-key.pub"
}
variable script_file {
  default = "../dockerinstall.sh"
}
```

## Variables for AWS
```
variable access_key {}  # AWS user account key
variable secret_key {}
```

## Variables for OCI
```
variable tenancy_ocid {
  default = "ocid1.tenancy.........."
}
variable user_ocid {
  default = "ocid1.user.oc1........."
}
variable fingerprint {
  default = "15:35:51:e2:05........."
}
variable compartment_ocid {
  default = "ocid1.compartment.oc1.."
}
variable image_source_ocid {
  default = "ocid1.image.oc1........"
}
variable private_key_path {
  default = "PATH_FOR_SSH_PEM_KEY/id_rsa.pem"
}
```