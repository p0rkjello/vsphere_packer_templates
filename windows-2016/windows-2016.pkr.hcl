source "vsphere-iso" "this" {
  convert_to_template   = true
  ## Floppy configuration
  # floppy_img_path (string) - Datastore path to a floppy image that will be mounted to the VM. Example: [datastore1] ISO/pvscsi-Windows8.flp.
  floppy_files          = [
    "autounattend.xml",
    "../scripts/disable-network-discovery.cmd",
    "../scripts/enable-rdp.cmd",
    "../scripts/enable-winrm.ps1",
    "../scripts/install-vm-tools.cmd",
    "../scripts/set-temp.ps1",
    "../scripts/microsoft-updates.bat",
    "../scripts/win-updates.ps1",
    "../scripts/disable-screensaver.ps1"
  ]
  # floppy_dirs ([]string) - List of directories to copy files from.
  # floppy_label (string) - The label to use for the floppy disk that is attached when the VM is booted. This is most useful for cloud-init, Kickstart or other early initialization tools, which can benefit from labelled floppy disks. By default, the floppy label will be 'packer'.
  
  ## Connection Configuration
  vcenter_server        = var.vsphere_vcenter_server
  username              = var.vsphere_username
  password              = var.vsphere_password
  insecure_connection   = true
  datacenter            = var.vsphere_datacenter

  ## Hardware Configuration
  CPUs                  = "${var.vm-cpu-num}"
  # cpu_cores (int32) - Number of CPU cores per socket.
  # CPU_reservation (int64) - Amount of reserved CPU resources in MHz.
  # CPU_limit (int64) - Upper limit of available CPU resources in MHz.
  # CPU_hot_plug (bool) - Enable CPU hot plug setting for virtual machine. Defaults to false.
  RAM                   = "${var.vm-mem-size}"
  # RAM_reservation (int64) - Amount of reserved RAM in MB.
  RAM_reserve_all       = true
  # RAM_hot_plug (bool) - Enable RAM hot plug setting for virtual machine. Defaults to false.
  # video_ram (int64) - Amount of video memory in KB.
  # vgpu_profile (string) - vGPU profile for accelerated graphics. See NVIDIA GRID vGPU documentation for examples of profile names. Defaults to none.
  # NestedHV (bool) - Enable nested hardware virtualization for VM. Defaults to false.
  # firmware (string) - Set the Firmware for virtual machine. Supported values: bios, efi or efi-secure. Defaults to bios.
  # force_bios_setup (bool) - During the boot, force entry into the BIOS setup screen. Defaults to false.

  ## Location Configuration
  vm_name               = "${var.vm-name}"
  folder                = "${var.vsphere-folder}"
  cluster               = "${var.vsphere-cluster}"
  # host (string) - ESXi host where target VM is created. A full path must be specified if the host is in a folder. For example folder/host. See the Working With Clusters And Hosts section above for more details.
  # resource_pool (string) - VMWare resource pool. If not set, it will look for the root resource pool of the host or cluster. If a root resource is not found, it will then look for a default resource pool.
  datastore             = "${var.vsphere-datastore}"
  # set_host_for_datastore_uploads (bool) - Set this to true if packer should use the host for uploading files to the datastore. Defaults to false.  

  ## Run Configuration
  # boot_order (string) - Priority of boot devices. Defaults to disk,cdrom

  ## Shutdown Configuration
  # shutdown_command (string) - Specify a VM guest shutdown command. This command will be executed using the communicator. Otherwise the VMware guest tools are used to gracefully shutdown the VM guest.
  # shutdown_timeout (duration string | ex: "1h5m2s") - Amount of time to wait for graceful VM shutdown. Defaults to 5m or five minutes. This will likely need to be modified if the communicator is 'none'.
  # disable_shutdown (bool) - Packer normally halts the virtual machine after all provisioners have run when no shutdown_command is defined. If this is set to true, Packer will not halt the virtual machine but will assume that you will send the stop signal yourself through a preseed.cfg, a script or the final provisioner. Packer will wait for a default of five minutes until the virtual machine is shutdown. The timeout can be changed using shutdown_timeout option.

  ## Wait Configuration
  # ip_wait_timeout (duration string | ex: "1h5m2s") - Amount of time to wait for VM's IP, similar to 'ssh_timeout'. Defaults to 30m (30 minutes). See the Golang ParseDuration documentation for full details.
  # ip_settle_timeout (duration string | ex: "1h5m2s") - Amount of time to wait for VM's IP to settle down, sometimes VM may report incorrect IP initially, then its recommended to set that parameter to apx. 2 minutes. Examples 45s and 10m. Defaults to 5s(5 seconds). See the Golang ParseDuration documentation for full details.
  # ip_wait_address (*string) - Set this to a CIDR address to cause the service to wait for an address that is contained in this network range. Defaults to "0.0.0.0/0" for any ipv4 address. Examples include:

  ## ISO Configuration  
  # iso_checksum (string) - The checksum for the ISO file or virtual hard drive file. The type of the checksum is specified within the checksum field as a prefix, ex: "md5:{$checksum}". The type of the checksum can also be omitted and Packer will try to infer it based on string length. Valid values are "none", "{$checksum}", "md5:{$checksum}", "sha1:{$checksum}", "sha256:{$checksum}", "sha512:{$checksum}" or "file:{$path}". Here is a list of valid checksum values:
  # iso_url (string) - A URL to the ISO containing the installation image or virtual hard drive (VHD or VHDX) file to clone.
  
  # ISO Configuration »Optional:
  # iso_urls ([]string) - Multiple URLs for the ISO to download. Packer will try these in order. If anything goes wrong attempting to download or while downloading a single URL, it will move on to the next. All URLs must point to the same file (same checksum). By default this is empty and iso_url is used. Only one of iso_url or iso_urls can be specified.
  # iso_target_path (string) - The path where the iso should be saved after download. By default will go in the packer cache, with a hash of the original filename and checksum as its name.
  # iso_target_extension (string) - The extension of the iso file after download. This defaults to iso.
 
  ## CDRom Configuration
  iso_paths             = ["${var.os_iso_path}", "[] /vmimages/tools-isoimages/windows.iso"]

  ## Create Configuration
  # vm_version (uint) - Set VM hardware version. Defaults to the most current VM hardware version supported by vCenter. See VMWare article 1003746 for the full list of supported VM hardware versions.
  guest_os_type         = "windows9Server64Guest"
  network_adapters {
    network             = var.vsphere_network
    network_card        = "vmxnet3"
  }
  #  usb_controller ([]string) - Create USB controllers for the virtual machine. "usb" for a usb 2.0 controller. "xhci" for a usb 3.0 controller. There can only be at most one of each.
  #  notes (string) - VM notes.
  disk_controller_type  = "lsilogic-sas"
  storage {
    disk_size             = var.vsphere_disk_size
    disk_thin_provisioned = true
  }
  
  ## Communicator configuration
  communicator          = "winrm"
  winrm_username        = var.vsphere_winrm_username
  winrm_password        = var.vsphere_winrm_password
  winrm_use_ssl         = true
  winrm_insecure        = true
}

build {
  sources = [
    "source.vsphere-iso.this"
  ]

  provisioner "windows-restart" {
    restart_timeout = "30m"
  }

  provisioner "windows-update" {
    filters         = [
      "exclude:$_.Title -like '*Preview*'",
      "exclude:$_.Title -like '*Cumulative*'",
      "exclude:$_.Title -like '*Kumulatives*'",
      "exclude:$_.Title -like '*VMware*'",
      "exclude:$_.Title -like '*Defender*'",
      "include:$true"
    ]
    pause_before    = "30s"
    search_criteria = "IsInstalled=0"
  }

  provisioner "windows-restart" {
  }
}
