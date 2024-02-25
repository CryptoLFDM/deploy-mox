# deploy-mox

Deploy Mox is composed of ansible playbooks & roles to deploy our applications & infrastructure. The main goal here is to deploy and maintain ou stack properly.

## What we deploy ?

actually, we have our proper monitoring stack, chia farmer, Grafana for multiple purpose and many blockchain nodes.

## Some words to understand

Well, I'm a big fan of grek mythologic, that's why all server are named from mythological creature. don't pay attention to this ;)

### Content mapping

````yaml
cerberus: elasticsearch
pegasus: haproxy
hydras: truenas
mermaid: grafana,kibana
minotor: custom go api
cyclops: proxmox host
chimera: node machine
centaur: chia farmer
basilisk: vault
````



## Prerequisite

- https://www.hashicorp.com/products/vault (I'm using it to store all secret)
- https://www.ansible.com/

## Repo Architecture

### roles

under `roles/` you will find all app we are running. We are trying to not have hard dependencies with our base code and will tend to have 100% compatibility with any ansible in the future.

### playbook

`deploy.yml` act as main playbook who run all other playbook.


## how run a playbook

for exemple

`ansible-playbook deploy.yml -i inventory/mox/hosts -k -K -u ${ANSIBLE_USER} -v -c paramiko -D`

will run all play from `deply.yml` with inventory `inventory/mox/hosts` and the remote user `${ANSIBLE_USER`. `-k` and `-K` will prompt for ssh password and sudo password.