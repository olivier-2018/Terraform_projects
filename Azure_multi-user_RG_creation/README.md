## Automated Azure groups creation using Terraform

This repository contains Terraform templates to automate the creation of Azure resource groups for several users.  
The template illustrate the use of module, variable and outputs in Terraform.  
In a nutshell, Terraform variables are defined using a list datastructure and used via a module to define resource groups and users.

### Features

- **Automated Resource Group Creation**: Define resource groups using variables and let Terraform handle the creation.
- **Consistency**: Ensure that resource groups are created in a consistent manner across different environments.
- **Scalability**: Easily add or remove resource groups by modifying the variables list.
- **Version Control**: Track changes to the infrastructure setup using version control.

### Setup environment variable and cd to the project folder

```sh
cd cd Azure_multi-user_RG_creation/modules/my_resourcegroup/
cp list_resourcegroups.auto.tfvars.sample list_resourcegroups.auto.tfvars
# Modify the list_resourcegroups.auto.tfvars file and add resource groups and user emails
```
