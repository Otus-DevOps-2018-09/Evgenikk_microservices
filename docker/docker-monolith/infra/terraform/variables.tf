variable project {
  description = "Project ID"
}

variable disk_image {
  description = "Disk image"
}

variable private_key_path {
  description = "Path to the private key used for ssh access"
  default     = "~/.ssh/id_rsa"
}

variable "app_count" {
  description = "number off app instances"
  default     = "1"
}

variable region {
  description = "Region, location of VM"
  default     = "europe-west1"
}


variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "app-reddit-base-ansible"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "mongo-base-ansible"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
  default = "~/.ssh/appuser.pub"
}


variable zone {
  description = "zone of app vm"
  default     = "europe-west1-b"
}
