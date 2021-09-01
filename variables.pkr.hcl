// variables.pkr.hcl

variable "vsphere_vcenter_server" {
  type        = string
  description = "vCenter server hostname"
}

variable "vsphere_username" {
  type        = string
  description = "vSphere username"
}

variable "vsphere_password" {
  type        = string
  default     = ""
  description = "vSphere password"
  sensitive   = true
}

variable "vsphere_datacenter" {
  type        = string
  default     = ""
  description = "VMware datacenter name"
}

variable "vm_name" {
  type        = string
  default     = ""
  description = "Name of the new VM to create"
}

variable "folder" {
  type        = string
  default     = "Templates"
  description = "VM folder to create the VM in"
}

variable "cluster" {
  type      = string
  description = "ESXi cluster where target VM is created"
}

variable "datastore" {
  type        = string
  description = "VMWare datastore. Required if host is a cluster, or if host has multiple datastores"
}

variable "iso_paths" {
  type        = list(string)
  description = "List of Datastore or Content Library paths to ISO files that will be mounted to the VM. "
}

variable "network" {
  type        = string
  default     = "VM Network"
  description = "Set the network in which the VM will be connected to"
}

variable "disk_size" {
  type        = int64
  default     = "32768"
  description = "The size of the disk in MB"
}

variable "winrm_username" {
  type        = string
  default     = "Administrator"
  description = "The username to use to connect to WinRM"
}

variable "winrm_password" {
  type      = string
  default   = "packer"
  sensitive = true
}
