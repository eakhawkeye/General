#!/bin/bash
# Script to upgrade Fedora however possible
# https://docs.fedoraproject.org/en-US/quick-docs/dnf-system-upgrade/#Resolving_post-upgrade_issues
# by: eakhawkeye

# Variables: User Defined
max_version=36
# Veriables: System Defined
current_version=$(awk '{print $3}' /etc/redhat-release)
version=$((current_version + 1))

# Ensure the vesrion doesn't exceed the configured limit
if [ ${current_version} -eq ${max_version} ]; then
	echo "System at max_version configured: ${max_version}"
    exit 0
fi

# Prepare system for upgrade
echo "Upgrading Fedora: ${current_version} -> ${version}"
sudo dnf upgrade -y --refresh
sudo dnf install -y dnf-plugin-system-upgrade
sudo dnf system-upgrade download --releasever=${version} --allowerasing --best -y && \

# Reboot the system to actually upgrade
read -p "Reboot? (y/n)" reboot
if [ "${reboot}x" == "yx" ]; then
	echo "Rebooting..."
	sudo dnf system-upgrade reboot
else
	echo "When you're ready to reboot, issue the following:"
	echo "sudo dnf system-upgrade reboot"
fi