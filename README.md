# deploy-mox

Deploy Mox is composed from ansible playbooks & roles to deploy our applications & infrastructure.

## Some words to understand

Well, I'm a big fan of grek mythologic, that's why all server are named from mythological creature. don't pay attention to this ;)

## roles

under `roles/` you will find all app we are running. We are trying to not have hard dependencies with our base code and will tend to have 100% comaptibility with any ansible in the future.

## playbook

`deploy.yml` act as main playbook who run all other playbook.
