
# Définition des dépendances
terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.9.14"
    }
  }
}

# Configuration du module proxmox

provider "proxmox" {
  pm_api_url = "https://192.168.0.83:8006/api2/json"
  pm_tls_insecure = true # Dans notre cas nous utilisons une instance sur le réseau local qui n'a pas de certificat HTTPs valide
}

# Définition d'une machine

resource "proxmox_vm_qemu" "cloud-init-test" {
  name = "cloudinit-test-vm"
  desc = "Première machine construire à l'aide de terraform"
  target_node = "yvan-lab-02"

  clone = "debian-cloud-init" # On clone une machine contenant une image cloudinit.

  network {
    bridge = "vmbr0"
    model = "e1000"
  }

  disk {
    type = "virtio"
    storage = "local-lvm"
    size = "30G"
    backup = false
  }

  os_type = "cloud-init"

  # Partie cloudinit

  ciuser = "yvan"
  cipassword= "test4232"
  ipconfig0="ip=dhcp" # Permet de configurer l'interface en DHCP
  sshkeys = <<EOF
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJq8ZUykN58S9tGCelIG0EpEVBWD4QgB5Zi3rEI1qiA9 pcportable-yvan
EOF


}