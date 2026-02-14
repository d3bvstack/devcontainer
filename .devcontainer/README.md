# Development Container

This directory contains a pre-configured development environment for Visual Studio Code. It ensures a consistent setup across different machines by isolating dependencies and configuration within a Docker container.

## Overview

The environment is built on **Debian 12 (Bookworm)** and is tailored for general-purpose backend development, with a focus on Python and system-level utilities.

### Included tools (what's in-image vs post-create)

The Docker image and the `postCreateCommand` together provide the development toolset. The table below clarifies where each package is installed (image vs post-create):

| Category | Tools (where installed) | Purpose |
| :--- | :--- | :--- |
| **Compiler** | `build-essential` (post-create) | GCC/G++/Make for compiling C-extensions (e.g., `numpy`, `cryptography`). |
| **Python** | `python3` (in-image), `python3-pip` (post-create) | Python runtime and package manager. |
| **Productivity** | `git`, `curl` (in-image); `fzf` (post-create) | Version control, HTTP client, fuzzy-finder. |
| **Diagnostics** | `procps`, `iproute2`, `iputils-ping` (post-create) | Process and network debugging (`ps`, `top`, `ping`). |
| **Archives** | `zip`, `unzip` (post-create) | Handling compressed artifacts and deployment packages. |

See `.devcontainer/Dockerfile` for packages baked into the image and `.devcontainer/devcontainer.json` for additional tooling installed by the `postCreateCommand`.

## Getting Started

### Prerequisites

1. **Docker Desktop** (or Docker Engine on Linux).
2. **Visual Studio Code**.
3. **Dev Containers Extension** ([ms-vscode-remote.remote-containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)).

### How to use

#### Method 1: VS Code (Recommended)
1. Open the project root folder in VS Code.
2. When prompted with "Reopen in Container", click **Reopen**.
   - *Alternatively: Press `F1`, type `Dev Containers: Reopen in Container`, and select it.*
3. VS Code will build the image and start the container. The first build may take a few minutes as it downloads the base image and runs the `postCreateCommand` defined in `.devcontainer/devcontainer.json`.

#### Method 2: GitHub Codespaces
This repository is fully compatible with GitHub Codespaces.
- Click the **Code** button on the GitHub repository page.
- Select the **Codespaces** tab and click **Create codespace on master**.
- Port 8000 will be automatically forwarded and accessible via the browser.

#### Method 3: Dev Container CLI
For headless environments or CI/CD, use the official `@devcontainers/cli`:
```bash
# Install the CLI
npm install -g @devcontainers/cli

# Build and start the container
devcontainer up --workspace-folder .

# Exec a command inside
devcontainer exec --workspace-folder . /bin/bash
```

#### Method 4: Manual Docker CLI
If you need to build the image independently of the Dev Container specification:
```bash
# Recommended: build from the repository root and point to the Dockerfile in .devcontainer
docker build -f .devcontainer/Dockerfile -t my-dev-image . \
  --build-arg USERNAME=$(whoami) \
  --build-arg USER_UID=$(id -u) \
  --build-arg USER_GID=$(id -g)

# Alternative: build using the .devcontainer folder as the context (Dockerfile-only)
# docker build -t my-dev-image .devcontainer \
#   --build-arg USERNAME=$(whoami) \
#   --build-arg USER_UID=$(id -u) \
#   --build-arg USER_GID=$(id -g)

# Run the container
docker run -it --rm \
  -v $(pwd):/workspaces/workspace \
  -w /workspaces/workspace \
  -p 8000:8000 \
  my-dev-image /bin/bash
```

## Configuration Details

### Port Forwarding & Conflicts
The environment is pre-configured to forward **Port 8000** (see the `forwardPorts` setting in `.devcontainer/devcontainer.json`). Any web server (e.g., Django, FastAPI, Flask) running on this port inside the container will be accessible at `http://localhost:8000` on your host machine.

#### Managing Conflicts
If port `8000` is already in use on your host machine:
- **Automatic Remapping**: VS Code will often detect the collision and automatically map the container's port to a different available port on your host (e.g., `8001`). You can verify the actual mapping in VS Code's **Ports** view.
- **Manual Change**: To permanently change the forwarded port, update the `forwardPorts` array in [.devcontainer/devcontainer.json](devcontainer.json).

#### Adding Additional Ports
To expose more services (like a database or a second web app), list them in the `forwardPorts` array:
```json
"forwardPorts": [8000, 5432, 6379]
```

### User & Permissions
The container runs as a non-root user (defaults to `vscode`, but can be overridden by the host's `$USER` environment variable).
- **UID/GID Mapping**: The `.devcontainer/Dockerfile` accepts `USER_UID`/`USER_GID` build arguments (and `devcontainer.json` passes your host UID/GID) so the container user matches your host — this prevents permission issues when editing mounted files.
- **Sudo Access**: The configured user has passwordless sudo privileges for administrative tasks.

## Customization

### VS Code Extensions & Settings
You can tailor the editor experience within the container by editing `customizations.vscode` in `.devcontainer/devcontainer.json`:
- **Extensions**: Add extension IDs to the `extensions` array.
- **Settings**: Add machine-specific or workspace settings to the `settings` object. These will override your local settings while in the container.

### Lifecycle Hooks
The environment supports several hooks in [devcontainer.json](devcontainer.json) for advanced setup:
1. **`onCreateCommand`**: Runs when the container is first created.
2. **`updateContentCommand`**: Runs whenever the container is resumed or workspace content changes.
3. **`postCreateCommand`**: (Used) Runs after the container is created and the user is connected.
4. **`postStartCommand`**: Runs every time the container starts.

### Environment Variables
To inject environment variables:
- **`containerEnv`**: Variables available to all processes in the container.
- **`remoteEnv`**: Variables specifically for VS Code and its sub-processes (terminals, etc.).

### Modifying the File System
- **Persistent Changes**: For global tools or OS-level configurations, edit the [Dockerfile](Dockerfile).
- **Transient Tools**: For project-specific dependencies (like `pip install`), use the `postCreateCommand` in `.devcontainer/devcontainer.json`.
