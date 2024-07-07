This Terraform configuration sets up a basic Azure infrastructure for development purposes. It creates a virtual network, subnet, security group, and a Linux virtual machine in the South Africa North (can be modified to be a region of your choice)

<h3>Resources created</h3>

<ul>
<li>Resource Group<li>
<li>Virtual Network<li>
<li>Subnet<li>
<li>Network Security Group<li>
<li>Network Interface<li>
<li>Public IP<li>
<li>Linux Virtual Machine<li>
</ul>

<br>
[!Prerequisites]

<ul>
<li>Terraform installed<li>
<li>Azure CLI installed and authenticated<li>
<li>SSH key pair (public key referenced in the code)<li>
<ul>

<h4>Usage<h4>

<ul>
<li>Clone this repository.<li>
<li>Navigate to the directory containing the Terraform files.<li>
<li>Initialize Terraform:<li>
<ul>

'terraform init' 

<li>Review and modify variables if needed.<li>
<li>Plan the deployment:<li>

terraform plan'

Apply the configuration:
Copyterraform apply


Configuration Details

<ul>
<li>The virtual network uses the address space 10.123.0.0/16<li>
<li>The subnet uses the address prefix 10.123.1.0/24<li>
<li>The security group allows all inbound traffic (modify for production use)<li>
<li>The VM uses an Ubuntu 18.04 LTS image<li>
<li>Custom data is applied to the VM from a customdata.tpl file (not provided in the snippet)<li>
<ul>

<h4>Outputs<h4>

The public IP address of the created VM is output after successful application.

[!Security Note]

The current security group configuration allows all inbound traffic. This is not recommended for production environments. Adjust the security rules as per your requirements.

<br>

[!Customization]

Modify the var.host_os variable to match your local operating system for the SSH script provisioner.
Ensure the customdata.tpl file exists and contains the desired bootstrap commands for the VM.

Clean Up
To destroy the created resources:
Copyterraform destroy
Remember to confirm the destruction to avoid unexpected costs.