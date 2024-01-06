# Azure

## Check results
```
resource_group_name=$(terraform output -raw resource_group_name)
az vm list --resource-group $resource_group_name --query "[].{\"VM Name\":name}" -o table
```

## References: 
* https://learn.microsoft.com/en-us/cli/azure/
* https://learn.microsoft.com/pt-br/azure/cost-management-billing/manage/mca-check-azure-credits-balance?tabs=portal
* https://learn.microsoft.com/pt-br/azure/cost-management-billing/manage/check-free-service-usage
* https://azuretracks.com/2021/04/current-azure-region-names-reference/
* https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
* https://medium.com/@david.e.munoz/devops-building-blocks-with-terraform-azure-and-docker-3ad8f78a77c6
* https://intodot.net/deploying-elasticsearch-with-terraform-to-a-virtual-machine-in-microsoft-azure/

