# HomelabRepo

Dokumentacija i automatizacija mog ličnog homelab-a — projekat kroz koji vežbam Linux, Ansible, Kubernetes, Docker, CI/CD... radeći na pravom hardveru umesto samo kroz tutoriale. Deployujem i dockerizujem sopstvene projekte (npr. `fitnessWebApp`), a plan je i GitOps u nekom trenutku.

## Šta je ovaj homelab

Jedan stariji nadogradjen laptop (Acer, Ryzen 7 5700U, 16 tredova, 19 GB RAM-a) na kome radi
**Proxmox VE**, a na njemu virtuelne mašine koje čine lab:

| VM | Ime | IP | OS | Uloga |
|----|-----|----|----|-------|
| 100 | rocky9-sandbox | 192.168.0.6 | Rocky Linux 9 | jumphost / Ansible kontrolni čvor |
| 101 | k3s-server-01 | 192.168.0.11 | Ubuntu 24.04 | k3s control-plane |
| 102 | k3s-worker-01 | 192.168.0.12 | Ubuntu 24.04 | k3s worker |
| 103 | k3s-worker-02 | 192.168.0.13 | Ubuntu 24.04 | k3s worker |
| 104 | k3s-worker-03 | 192.168.0.14 | Ubuntu 24.04 | k3s worker |

Klaster: **k3s (Kubernetes v1.36)** — jedan control-plane + tri workera.
Pristup sa bilo kog mesta preko **Tailscale** (subnet router na Proxmox hostu).

## Struktura repa

```
HomelabRepo/
├── Ansible/          # automatizacija: inventory, playbooks, skripte
│   ├── inventory/
│   │   ├── inventory.home.yaml    # fiksni VM-ovi kod kuće (k3s_control, k3s_workers)
│   │   └── inventory.aws_ec2.yaml # dynamic inventory — EC2 po tagu Project=ansible-lab
│   ├── playbooks/
│   └── scripts/
├── Bash/             # shell skripte i vežbe
└── Python/           # Python skripte, automatizacija, vežbe
```

## Ansible — kako se koristi

Kontrolni čvor je **rocky9-sandbox**. Iz ovog repa, sa sandboxa:

```bash
cd ~/HomelabRepo/Ansible
ansible all -i inventory/inventory.home.yaml -m ping          # provera da sve radi
ansible k3s_workers -i inventory/inventory.home.yaml -m ping  # samo workeri
```

AWS varijanta (dynamic inventory — hostovi se sami pronalaze po tagovima):

```bash
ansible all -i inventory/inventory.aws_ec2.yaml -m ping
```

## Napomene

- Sve tajne (ključevi, tokeni, AWS kredencijali) ostaju **van repa :)**
