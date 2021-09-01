variable "vsphere_vcenter_server" {
  type      = string
  default   = ""
  sensitive = false
}

variable "vsphere_username" {
  type      = string
  default   = ""
  sensitive = false
}

variable "vsphere_password" {
  type      = string
  default   = ""
  sensitive = true
}

variable "vsphere_datacenter" {
  type      = string
  default   = ""
  sensitive = false
}

variable "vsphere_cluster" {
  type      = string
  default   = ""
  sensitive = false
}

variable "vsphere_datastore" {
  type      = string
  default   = ""
  sensitive = false
}

variable "vsphere_network" {
  type      = string
  default   = "VM Network"
  sensitive = false
}

variable "vsphere_winrm_username" {
  type      = string
  default   = ""
  sensitive = false
}

variable "vsphere_winrm_password" {
  type      = string
  default   = ""
  sensitive = true
}