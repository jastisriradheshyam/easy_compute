# Fedora setup

Latest version: 36

## List of applications & App specific customizations

- Docker
- Docker Compose
- Kubernetes
- Minikube

- VS Code
  - ```json
    "editor.fontFamily": "JetBrains Mono, monospace, 'Droid Sans Mono'",
    "editor.fontLigatures": true
    ```
  - for zsh powerlevel10k
    - `terminal.integrated.fontFamily` : `MesloLGS NF, monospace, Nerd Font, Source Code Pro`
- Tilix
  - `sudo dnf install tilix`
- ZSH
  - `sudo dnf install zsh`
  - Oh my zsh : `sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
  - Theme: powerlevel10k
    - `git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k`
    - update `ZSH_THEME` to `ZSH_THEME="powerlevel10k/powerlevel10k"` in `~/.zshrc`


## Extras & Notes
- Alternative to powerlevel10k is [starship shell prompt](https://starship.rs/)

## References:
- https://www.jetbrains.com/lp/mono/
