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

- **Robust User Mapping**: Automated UID/GID synchronization ensures file permissions match your host user. The build process includes numeric validation to handle missing or invalid host IDs gracefully, defaulting to `1000`.
- **VS Code Integration**:
    - **Default Shell**: Pre-configured to use `bash`.
    - **Extensions**: Includes [`Doxygen Documentation Generator`](https://marketplace.visualstudio.com/items?itemName=cschlosser.doxdocgen) (`cschlosser.doxdocgen`) for standardized code documentation.
- **Non-Root Access**: Runs as the `vscode` user with full passwordless `sudo` privileges.

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

- **Default behavior**: The container runs as the `vscode` user. UID/GID synchronization remains enabled (`updateRemoteUserUID: true`) to ensure file permissions match your host user.

- **Where this is configured**:
  - In `devcontainer.json`:
    - `"remoteUser": "vscode"`
    - `"updateRemoteUserUID": true`
    - Build args `USER_UID` and `USER_GID` are set to `1000` for consistent builds.
  - In `Dockerfile`: The build process validates that the UID/GID are numeric and non-negative, preventing failures when host environment variables are unavailable.

- **How to verify inside the container**:
  - `echo $USER`
  - `id -u && id -g`

- **How to force a specific user**:
  - To run as a different user, set `"remoteUser"` in `devcontainer.json` to that username (ensure the user exists in the image) and rebuild.

> ⚠️ Note: Changing `remoteUser` requires rebuilding the container (use **Dev Containers: Rebuild Container** from the Command Palette).

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


