#!/bin/sh

which jq
if [ $? -ne 0 ]; then
  echo "jq is not present, install jq first"
  exit 1;
fi

docker_buildx_version=$(curl -L https://api.github.com/repos/docker/buildx/releases/latest | jq '.tag_name')
docker_cli_plugins_path=/usr/libexec/docker/cli-plugins
docker_buildx_plugin_path=${docker_cli_plugins_path}/docker-buildx
mkdir -p ${docker_cli_plugins_path}
curl -OL https://github.com/docker/buildx/releases/download/${docker_buildx_version}/buildx-${docker_buildx_version}.linux-arm64
mv buildx-v0.10.4.linux-arm64 ${docker_buildx_plugin_path}
chmod +x ${docker_buildx_plugin_path}
docker buildx install
