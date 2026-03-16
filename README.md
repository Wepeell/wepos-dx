# WepOS-DX - Wepeell OS Developer Edition

This is a variant of [WepOS](https://github.com/Wepeell/wepos) (`wepos:latest`) with some extra tools, which in turn is based on [Bazzite](https://github.com/ublue-os/bazzite) (`bazzite:stable`).

## Things added

- [Docker](https://docs.docker.com/engine/install/fedora)
- [VS Code](https://github.com/microsoft/vscode)

## Custom wjust commands

Most of the personal customizations are done in the userspace with just recipes. 

Run `wjust` to list them all.

## Install

Download and install Bazzite first.

Then run:

```bash
sudo bootc switch --enforce-container-sigpolicy ghcr.io/wepeell/wepos-dx:latest
```

## Uninstall

To switch back to Bazzite:

```bash
sudo bootc switch --enforce-container-sigpolicy ghcr.io/ublue-os/bazzite:stable
```
