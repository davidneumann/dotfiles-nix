# Nix home manager
```bash
ln -s "$(pwd)/home.nix" ~/.config/home-manager/home.nix
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
home-manager switch
```

# Nixos
```bash
ln -s "$(pwd)/configuration.nix" /etc/nixos/configuration.nix
nixos-rebuild switch --use-remote-sudo
```
