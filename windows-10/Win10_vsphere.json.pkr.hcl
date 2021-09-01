packer {
  required_plugins {
    windows-update = {
      version = "0.14.0"
      source = "github.com/rgl/windows-update"
    }
  }
}

source "vsphere-iso" "this" {

  convert_to_template   = true

  // Floppy configuration
  floppy_files          = [
    "autounattend.xml",
    "../scripts/disable-network-discovery.cmd",
    "../scripts/enable-rdp.cmd",
    "../scripts/enable-winrm.ps1",
    "../scripts/install-vm-tools.cmd",
  #  "../scripts/set-temp.ps1",
  #  "../scripts/microsoft-updates.bat",
  #  "../scripts/win-updates.ps1",
    "../scripts/disable-screensaver.ps1"
  ]

  // Connection Configuration
  vcenter_server        = var.vsphere_vcenter_server
  username              = var.vsphere_username
  password              = var.vsphere_password
  insecure_connection   = true
  datacenter            = var.vsphere_datacenter

  // Hardware Configuration
  CPUs                  = 2
  RAM                   = 4096
  RAM_reserve_all       = true

  // Location Configuration
  vm_name               = var.vm_name
  folder                = var.folder
  cluster               = var.cluster
  datastore             = var.datastore

  // CDRom Configuration
  iso_paths             = [
    "${var.iso_path}",
    "[] /vmimages/tools-isoimages/windows.iso"
  ]

  // Create Configuration
  guest_os_type         = "windows9Server64Guest"

  network_adapters {
    network             = var.network
    network_card        = "vmxnet3"
  }

  disk_controller_type  = ["pvscsi"]

  storage {
    disk_size             = var.disk_size
    disk_thin_provisioned = true
  }

  // Communicator configuration
  communicator          = "winrm"
  winrm_username        = var.winrm_username
  winrm_password        = var.winrm_password
  winrm_use_ssl         = true
  winrm_insecure        = true
}

build {
  sources = [
    "source.vsphere-iso.this"
  ]

  provisioner "windows-restart" {}
}

