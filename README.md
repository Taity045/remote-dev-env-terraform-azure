# A Terraform-managed remote dev environment on Azure for VS Code with Docker Preinstalled

  

This Terraform configuration sets up a basic Azure infrastructure for development purposes. It creates a virtual network, subnet, security group, and a Linux virtual machine in the South Africa North region (can be modified to a region of your choice).

  

### Resources created

  

- Resource Group

- Virtual Network

- Subnet

- Network Security Group

- Network Interface

- Public IP

- Linux Virtual Machine

  

## Prerequisites

  

- Terraform installed

- Azure CLI installed and authenticated

- SSH key pair (public key referenced in the code)

  

### Usage

  

1. Clone this repository.

2. Navigate to the directory containing the Terraform files.

3. Initialize Terraform:

`terraform init`

  **Review and modify variables needed**

Plan the deployment:

    terraform plan

Apply  the  configuration:

    terraform apply

 **Configuration Details**


- The virtual network uses the address space 10.123.0.0/16.

- The subnet uses the address prefix 10.123.1.0/24.

- The security group allows all inbound traffic (modify for production use).

- The VM uses an Ubuntu 18.04 LTS image.

- Custom data is applied to the VM from a `customdata.tpl` file

  **Outputs**

*The public IP address of the created VM is output after successful application.*

  **Security Note!**

The current security group configuration allows all inbound traffic. This is not recommended for production environments. Adjust the security rules as per your requirements.

**Customization**

- Modify the `var.host_os` variable to match your local operating system for the SSH script provisioner.

- Ensure the `customdata.tpl file` exists and contains the desired bootstrap commands for the    VM.

**Clean Up**

***To destroy the created resources:***

    terraform destroy

Remember to confirm the destruction to avoid unexpected costs.
