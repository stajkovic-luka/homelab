# Homelab

Documentation and automation for my personal homelab — a project through which I practice Linux, Ansible, Kubernetes, Docker, CI/CD... by working on real hardware instead of only following tutorials. I deploy and dockerize my own projects (e.g. `fitnessWebApp`), and GitOps is planned at some point.

## What this homelab is

An older upgraded laptop (Acer, Ryzen 7 5700U, 16 threads, 19 GB RAM) running
**Proxmox VE**, with virtual machines that make up the lab:

| VM | Name | IP | OS | Role |
|----|------|----|----|------|
| 100 | rocky9-sandbox | 192.168.0.6 | Rocky Linux 9 | jumphost / Ansible control node |
| 101 | k3s-server-01 | 192.168.0.11 | Ubuntu 24.04 | k3s control-plane |
| 102 | k3s-worker-01 | 192.168.0.12 | Ubuntu 24.04 | k3s worker |
| 103 | k3s-worker-02 | 192.168.0.13 | Ubuntu 24.04 | k3s worker |
| 104 | k3s-worker-03 | 192.168.0.14 | Ubuntu 24.04 | k3s worker |

Cluster: **k3s (Kubernetes v1.36)** — one control-plane + three workers.
Accessible from anywhere via **Tailscale** (subnet router on the Proxmox host).

## Repository structure

```
HomelabRepo/
├── Ansible/          # automation: inventory, playbooks, scripts
│   ├── inventory/
│   │   ├── inventory.home.yaml    # static home VMs (k3s_control, k3s_workers)
│   │   └── inventory.aws_ec2.yaml # dynamic inventory — EC2 instances by Project=ansible-lab tag
│   ├── playbooks/
│   └── scripts/
├── Bash/             # shell scripts and exercises
└── Python/           # Python scripts, automation, exercises
```

## Ansible — usage

The control node is **rocky9-sandbox**. From this repo, on the sandbox:

```bash
cd ~/HomelabRepo/Ansible
ansible all -i inventory/inventory.home.yaml -m ping          # sanity check
ansible k3s_workers -i inventory/inventory.home.yaml -m ping  # workers only
```

AWS variant (dynamic inventory — hosts are discovered by tags):

```bash
ansible all -i inventory/inventory.aws_ec2.yaml -m ping
```

## Notes

- All secrets (keys, tokens, AWS credentials) stay **out of the repo :)**
