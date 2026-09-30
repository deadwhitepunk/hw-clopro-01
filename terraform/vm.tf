data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2404-lts"
}

resource "yandex_compute_instance" "nat-instance" {
  name        = "nat-instance"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public_subnet.id
    ip_address = "192.168.10.254"
    nat = true 
  }

  metadata = {
      user-data          = file("./cloud-init.yml")
      serial-port-enable = 1
    }
}

resource "yandex_compute_instance" "public" {
  name        = "public"
  hostname    = "public"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 20
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public_subnet.id
    nat                = true
  }
  
  scheduling_policy { preemptible = true }

  metadata = {
      user-data          = file("./cloud-init.yml")
      serial-port-enable = 1
    }
}

resource "yandex_compute_instance" "private" {
  name        = "private"
  hostname    = "private"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 20
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private_subnet.id
    nat                = false
  }
  
  scheduling_policy { preemptible = true }

  metadata = {
      user-data          = file("./cloud-init.yml")
      serial-port-enable = 1
    }
}