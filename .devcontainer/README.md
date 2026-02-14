# Development Container

This workspace provides a standardized, lightweight development environment based on **Debian 12.13-slim**, optimized for Python and systems-level development.

## Link index

- [Key Features](#key-features)
- [Available Tools](#available-tools)
- [Networking](#networking)
- [User & permissions](#user-permissions)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [How to Use](#how-to-use)
- [Use this devcontainer in another project](#use-this-devcontainer-in-another-project)

## Key Features

- **SSH Agent Forwarding**: Seamlessly use your host's SSH keys within the container. The `SSH_AUTH_SOCK` is automatically mounted to `/ssh-agent.sock`, enabling Git operations and remote access without exposing sensitive keys.
- **Dynamic User Mapping**: Automated UID/GID synchronization ensures that file permissions inside the container match your host user, preventing "permission denied" issues when editing workspace files.
- **VS Code Integration**:
    - **Default Shell**: Pre-configured to use `bash`.
    - **Extensions**: Includes [`Doxygen Documentation Generator`](https://marketplace.visualstudio.com/items?itemName=cschlosser.doxdocgen) (`cschlosser.doxdocgen`) for standardized code documentation.
- **Non-Root Access**: Runs as the `vscode` user with full passwordless `sudo` privileges for administrative tasks.

## Available Tools

The environment includes a curated set of tools installed both in the base image and during the "hydration" phase (`postCreateCommand`):

- **Development**: `git`, `openssh-client`, `curl`, `build-essential` (GCC/G++/Make).
- **Python**: `python3`, `python3-pip`.
- **Productivity & Utilities**: `fzf` (fuzzy finder), `zip`, `unzip`, `procps` (`ps`, `top`).
- **Networking**: `iproute2`, `iputils-ping`, `ca-certificates`.

## Networking

- **Default Port**: Port **8000** is forwarded by default. Any service running on this port inside the container will be accessible at `http://localhost:8000` on your host.
- **Port Management**: If Port 8000 is occupied, VS Code will automatically remap it (check the **Ports** view). You can expose additional ports by updating the `forwardPorts` array in [`devcontainer.json`](devcontainer.json).

<a id="user-permissions"></a>
## User & permissions

- **Default behavior**: The container runs as your **host user** by default (username + UID/GID are synced). If VS Code cannot obtain the host user info, it falls back to the `vscode` user.

- **Where this is configured**:
  - In `devcontainer.json`:
    - `"remoteUser": "${localEnv:USER:-vscode}"`
    - `"updateRemoteUserUID": true` (ensures UID/GID sync)
  - In `Dockerfile`: build args `USER_UID`, `USER_GID`, `USERNAME` are used to create the container user with matching UID/GID and grant passwordless `sudo`.

- **How to verify inside the container**:
  - `echo $USER`
  - `id -u -n && id -u && id -g`

- **How to force a specific user**:
  - To force the `vscode` user: set `"remoteUser": "vscode"` in `devcontainer.json` and rebuild the container.
  - To run as a different user, set `"remoteUser"` to that username (ensure the user exists in the image) and rebuild.

> ⚠️ Note: Changing `remoteUser` or UID/GID mapping requires rebuilding the container (use **Dev Containers: Rebuild Container** from the Command Palette).

## Getting Started

### Prerequisites
- [Docker Desktop](https://www.docker.com/products/docker-desktop) (or Docker Engine on Linux).
- [Visual Studio Code](https://code.visualstudio.com/).
- [Dev Containers Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers).

### How to Use

1. **Open Workspace**: Open the project root folder in VS Code.
2. **Reopen in Container**: When prompted, click **Reopen in Container**. Alternatively, press `F1` and run `Dev Containers: Reopen in Container`.
3. **Wait for Setup**: The first build handles the image pull and runs the `postCreateCommand` to install additional utilities.

---
*For modifications, see [Dockerfile](Dockerfile) for system-level changes or [devcontainer.json](devcontainer.json) for VS Code settings and lifecycle hooks.*

## Use this devcontainer in another project

You can reuse the `.devcontainer` from this repository in any project:

- Quick installer (recommended):

```bash
# run from inside your project folder
curl -fsSL https://raw.githubusercontent.com/d3bvstack/devcontainer/master/install-devcontainer.sh | bash -s -- .
```

- As a git submodule:

```bash
git submodule add https://github.com/d3bvstack/devcontainer.git .devcontainer
```

- Open the target project in VS Code and run **Dev Containers: Reopen in Container**.

This repository is compatible with GitHub Codespaces (use the **Open in Codespaces** badge in the root README to launch one).


