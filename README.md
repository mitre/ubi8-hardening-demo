## UBI8 Container Hardening Workflow Demo

A sample workflow for hardening a UBI8 container against a STIG using Packer and Ansible, including a scanning step and a threshold validation step to verify compliance.

### Dependencies

- [Docker](https://docs.docker.com/) - Container engine.
- [Packer](https://developer.hashicorp.com/packer) - A container image builder tool.
- [Ansible](https://docs.ansible.com/) - An orchestration tool that can target containers. Used as the provisioner to STIG-harden the container under Packer's direction.
- [Trivy](https://github.com/aquasecurity/trivy#get-trivy) - A container based scanning tool to search for vulnerabilities / CVE's.
- Ansible Lockdown's [STIG-hardening Ansible playbook](https://github.com/ansible-lockdown/RHEL8-STIG) for hardening Red Hat 8 to STIG standard. (This dependency is pulled in automatically by Packer's management of Ansible; you don't need to install this one yourself.)
- Progress Chef's [InSpec](https://docs.chef.io/inspec/) testing framework.
- MITRE SAF(c)'s InSpec profile for the [RHEL8 STIG](https://github.com/mitre/redhat-enterprise-linux-8-stig-baseline) for testing the results of the hardening process.
- [SAF CLI](https://saf-cli.mitre.org) for validating the results of the InSpec scan against a defined threshold (e.g. "95% of tests pass", or "no high-severity failures")
- [jmespath](https://pypi.org/project/jmespath/) - this is a python package that is a dependency for the RHEL8 STIG-hardening ansible playbook. It can be installed using `pip install jmespath` or `python3 -m pip install jmespath`

### Usage

There are two different ways that this project can be used:
- Manually (Done on a local machine)
- Automatically (A pipeline using Github Actions)

#### Manually

1) Install dependencies. See their respective docs linked above.
2) Clone this repo and change directory into it. `git clone https://github.com/mitre/ubi8-hardening-demo.git && cd ubi8-hardening-demo` 
3) Run `packer init .` to get Packer to install the Ansible and Docker plugins.
4) Run `packer build ubi8-hardened.pkr.hcl` to build, test, and save the hardened image.

#### Automatically

There are two triggers for the pipeline to run:
- To run the workflow manually you go to the actions page [HERE](https://github.com/mitre/ubi8-hardening-demo/actions/workflows/main.yml) and press the `Run workflow` button.
- The workflow will also run everytime a new commit is pushed to the main branch.

### Notes
- You can add additional types of scanning beyond InSpec (or get InSpec to run more than one testing profile) by modifying the `scripts/scan.sh` file. See the [MITRE SAF(c) Validation Library](https://saf.mitre.org/#/validate) for more InSpec profiles, or use your favorite image scanning tool.
- The `verify_threshold.sh` script will tag the generated image as "passing" if it exceeds the compliance threshold set in `threshold.yml`, and "failing" if it does not. A real hardening pipeline would instead do something like push an image that passes the threshold to a registry, and simply ignore it if it does not.