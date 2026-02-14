# Dev Container — clone & run

[![Open in Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new?repo=d3bvstack/devcontainer)

Make it easy to reuse this repository's development container in any project — clone this repo (or use the installer script) and `Reopen in Container` from VS Code.

## Link index

- [Quick start — copy into an existing project](#quick-start-copy-into-an-existing-project)
- [Usage](#usage)
- [Features](#features)
- [For GitHub Codespaces](#for-github-codespaces)
- [Installer script](#installer-script)
- [See also](#see-also)

## Quick start — copy into an existing project

Option A — use the installer script (recommended):

```bash
# from inside your project folder
curl -fsSL https://raw.githubusercontent.com/d3bvstack/devcontainer/master/install-devcontainer.sh | bash -s -- .
# then in VS Code: Command Palette → Dev Containers: Reopen in Container
```

Option B — add as a git submodule:

```bash
cd your-project
git submodule add https://github.com/d3bvstack/devcontainer.git .devcontainer
```

Option C — copy files manually:

```bash
cp -r path/to/devcontainer/.devcontainer ./
```

## Usage

- Open the project folder in VS Code.
- Run **Dev Containers: Reopen in Container** (Command Palette) or use the green prompt when VS Code detects a `.devcontainer` folder.

## Features

- **Reliable User Mapping**: Built-in validation ensures the container always starts with a valid UID/GID (defaulting to 1000).
- **Hardened Configuration**: Minimized `devcontainer.json` to reduce host environment dependencies.
- **Debian-slim Base**: Includes common dev tools installed via `postCreateCommand`.

## For GitHub Codespaces

This devcontainer is compatible with GitHub Codespaces (same `.devcontainer` config). Click the **Open in Codespaces** badge above to start a Codespace using this repository.

## Installer script

The `install-devcontainer.sh` script copies the `.devcontainer` folder into a target project (supports `--force` and `--submodule`). Use the `curl | bash` command shown above to run it remotely.

## See also

- [`.devcontainer/README.md`](.devcontainer/README.md) — detailed container notes and verification commands.
