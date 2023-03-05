# Fedora major version upgrade

## Update current packages to latest

- `sudo dnf upgrade --refresh`

## Install Upgrade plugin

- `sudo dnf install dnf-plugin-system-upgrade`

## Upgrade to a specific major version

- `sudo dnf system-upgrade download --releasever=REPLACE_WITH_MAJOR_VERSION`

## Once done restart the system

- `sudo dnf system-upgrade reboot`

## After official release data (if upgrade was done in beta phase):

- `sudo dnf distro-sync`

# References:

[1]: [Upgrading to a new release of Fedora :: Fedora Docs](https://docs.fedoraproject.org/en-US/quick-docs/upgrading/)