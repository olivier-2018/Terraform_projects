# Terraform projects

This repository gathers a bunch of Terraform projects used with various cloud providers.
The goal is to gather relevant info on Terraform templates to learn how to work with different cloud providers (initially Azure).

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed
- Azure CLI installed and authenticated
- An Azure subscription

## Projects description and features

- Azure_VM_deployment:

  - Creates ResourceGroup, Vnet, Subnets, PublicIP, NetworkInterface resources and deploys a **B1ls VM instance** to Azure and run some installation scripts to configure Docker automatically.
  - Features: basic Azure provider resources, TF variables, TF outputs, Env. variables, scripts

- Azure_multi-user_RG_creation:

  - Automates multiple Azure resource groups creation for **multi-user isolation**
  - Features: TF modules, TF variables, TF outputs, TF data

- Azure_K8s_cluster_deployment:

  - Creates basic Azure resources and deploys a **Kubernetes cluster** in Azure
  - Feature: TF Kubernetes resources, outputs

## Getting Started

### 1. Setup environment variable and cd to the project folder

```sh
cp script-env.sample script-env
# Modify the script-env file and source it
source script-env
cd <project_folder>
```

### 2. Initialize Terraform

```sh
terraform init
```

This command initializes the working directory containing the Terraform configuration files.

```sh
terraform fmt
```

This command formats the Terraform configuration files.

```sh
terraform validate
```

This command will validate the Terraform configuration files.

### 3. Plan the Infrastructure

```sh
terraform plan
# option: -out="filename"
```

This command creates an execution plan, showing what actions Terraform will take to achieve the desired state.

### 4. Apply the Configuration

```sh
terraform apply
# options: -auto-approve, -destroy, tf apply -replace <resource>, -refresh-only
```

This command applies the changes required to reach the desired state of the configuration.

### 5. Destroy the Infrastructure

```sh
terraform destroy
```

This command destroys the infrastructure managed by Terraform.

## Querying Resources

### Show the current state

```sh
terraform show
```

This command shows the current state of the infrastructure.

### List all resources

```sh
terraform state list
```

This command lists all resources in the state file.

### Show resource details

```sh
terraform state show <resource_name>
```

This command shows detailed information about a specific resource.

### Show output data

```sh
terraform output <data_name>
```

This command shows an output data value.

### Terraform console

```sh
terraform console
# querie: var.<myvar>
# options: -var="host_os=linux", -var-file="newFile.tfvars",
```

## Useful Links

- [Terraform Documentation](https://www.terraform.io/docs)
- [Azure Kubernetes Service Documentation](https://docs.microsoft.com/en-us/azure/aks/)
- [Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
