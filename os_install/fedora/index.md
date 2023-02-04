# Fedora setup

Latest version: 37

## List of applications & App specific customizations

- Docker
- Docker Compose
- Kubernetes
- Minikube
- GNOME
  - Extenstions
    - Vitals
      - https://extensions.gnome.org/extension/1460/vitals/
    - Hide Top Bar
      - https://extensions.gnome.org/extension/545/hide-top-bar/
    - User Themes
      - https://extensions.gnome.org/extension/19/user-themes/
    - Window List
      - https://extensions.gnome.org/extension/602/window-list/
    - `Burn My Windows` by `Simme`
      - https://extensions.gnome.org/extension/4679/burn-my-windows/
    - `Tactile` by `lundal`
      - https://extensions.gnome.org/extension/4548/tactile/
  - Themes
    - Nord
      - https://github.com/EliverLara/Nordic
      - https://www.nordtheme.com/
- VS Code
  - ```json
    "editor.fontFamily": "JetBrains Mono, monospace, 'Droid Sans Mono'",
    "editor.fontLigatures": true
    ```
  - GPU
    - ```json
      "terminal.integrated.gpuAcceleration": "on"
      ```
  - for zsh powerlevel10k
    - `terminal.integrated.fontFamily` : `MesloLGS NF, monospace, Nerd Font, Source Code Pro`
  - Extentions
    - `Prettier - Code formatter`
  - Themes
    - Nord : https://marketplace.visualstudio.com/items?itemName=arcticicestudio.nord-visual-studio-code
    - Github Dark Dimmed : https://marketplace.visualstudio.com/items?itemName=GitHub.github-vscode-theme
- Tilix
  - `sudo dnf install tilix`
  - Set `JetBrains Mono` as Font
- ZSH
  - `sudo dnf install zsh`
  - Oh my zsh : `sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
    - Upgrade: `upgrade_oh_my_zsh` or `omz update`
  - Theme: powerlevel10k
    - `git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k`
    - update `ZSH_THEME` to `ZSH_THEME="powerlevel10k/powerlevel10k"` in `~/.zshrc`
  - Disable share history options
    - `unsetopt sharehistory`
    - List the options that are enabled by `setopt` command
      - for more info : `man zshoptions`

    - or add this to the `$ZSH_CUSTOM/keybinding_history.zsh`
    ```sh
    up-line-or-local-history() {
    zle set-local-history 1
    zle up-line-or-search
    zle set-local-history 0
    }
    zle -N up-line-or-local-history

    down-line-or-local-history() {
        zle set-local-history 1
        zle down-line-or-search
        zle set-local-history 0
    }
    zle -N down-line-or-local-history

    bindkey "^[[A" up-line-or-beginning-search
    bindkey "^[[B" down-line-or-beginning-search
    bindkey "^[[1;5A" up-line-or-local-history    # [CTRL] + Cursor up
    bindkey "^[[1;5B" down-line-or-local-history  # [CTRL] + Cursor down

    #bindkey "^[[1;5A" up-line-or-search    # [CTRL] + Cursor up
    #bindkey "^[[1;5B" down-line-or-search  # [CTRL] + Cursor down

    #bindkey "^[[1;3A" up-line-or-local-history    # [ALT] + Cursor up
    #bindkey "^[[1;3B" down-line-or-local-history  # [ALT] + Cursor down
    ```
- `btop`
  - `sudo dnf install btop`
- Firefox
  - `about:config`
    - `layers.acceleration.force-enabled` : `true`
      - In `about:support`, the `Compositing`	should be `WebRender` not `WebRender (Software)` after the change (requires restart)
      - Not working with NVidia graphs, only works with Intel graphics
  - Extensions
    - [uBlock Origin](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/)
    - [Privacy Badger](https://addons.mozilla.org/en-US/firefox/addon/privacy-badger17/)
    - [Decentraleyes](https://addons.mozilla.org/en-US/firefox/addon/decentraleyes/)
    - [Firefox Multi-Account Containers](https://addons.mozilla.org/en-US/firefox/addon/multi-account-containers/)
- NVidia
  - NVidia can be removed but disabling it will give flexibility 
  - Disabling will give fell snappy and also save power but due to inability of Linux to handle Nvidia hardware causes 100% usage of GPU so just install and disable by setting modeset to 0
  - `sudo grubby --update-kernel=ALL --args=rd.driver.blacklist=nouveau`
  - `sudo grubby --update-kernel=ALL --args=modprobe.blacklist=nouveau`
  - `sudo grubby --update-kernel=ALL --args=nvidia-drm.modeset=0`
  - `sudo systemctl disable nvidia-powerd.service`
  - If you want to disable drivers heres the list: `,nvidia,nvidia_drm,nvidia_modeset,nvidia_uv`
- Intel Wifi
  - Do not disable `nomsi` in `pci` inside the kernel parameters, it will cause wifi driver to fail, only disable aer by running this command: `sudo grubby --update-kernel=ALL --args=pci=noaer`
    - issue: https://groups.google.com/g/linux.kernel/c/sNsk4MGvmXQ?pli=1
## Extras & Notes
- Alternative to powerlevel10k is [starship shell prompt](https://starship.rs/)

## References:
- https://www.jetbrains.com/lp/mono/
- https://superuser.com/questions/446594/separate-up-arrow-lookback-for-local-and-global-zsh-history/691603
- https://stackoverflow.com/questions/9502274/last-command-in-same-terminal
- https://fedoraproject.org/wiki/Firefox_Hardware_acceleration
- https://www.michael1e.com/how-to-update-oh-my-zsh/
