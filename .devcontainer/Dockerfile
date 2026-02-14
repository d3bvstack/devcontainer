FROM debian:12.13-slim

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000

# Validate USER_UID/USER_GID are numeric (no negatives); default to 1000 if invalid
RUN case "$USER_UID" in ''|*[!0-9]*) USER_UID=1000 ;; esac \
 && case "$USER_GID" in ''|*[!0-9]*) USER_GID=1000 ;; esac \
 && echo "Using build UID:GID -> ${USER_UID}:${USER_GID} (user=${USERNAME})"

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get upgrade \
    && apt-get install -y --no-install-recommends \
    git \
    openssh-client \
    curl \
    locales \
    ca-certificates \
    python3 \
    sudo \
    && if ! getent group "$USERNAME" >/dev/null 2>&1; then groupadd -g "$USER_GID" "$USERNAME"; fi \
    && if ! id -u "$USERNAME" >/dev/null 2>&1; then useradd -s /bin/bash -m --uid "$USER_UID" --gid "$USER_GID" "$USERNAME"; fi \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && rm -rf /var/lib/apt/lists/*

ENV HOME=/home/${USERNAME}
ENV PATH=${HOME}/.local/bin:${PATH}

USER ${USERNAME}
