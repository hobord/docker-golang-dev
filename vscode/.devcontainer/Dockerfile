FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

ARG GO_VERSION=1.15.3
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ENV GO_VERSION=$GO_VERSION \
    GOOS=linux \
    GOARCH=amd64 \
    GOROOT=/golang/go \
    GOPATH=/golang/go-tools
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH
ARG USERNAME=vscode


RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
    #
    # Verify git, process tools, lsb-release (common in install instructions for CLIs) installed
    && apt-get -y install git openssh-client less iproute2 procps lsb-release \
        curl \
		make \
        netcat \
        telnet \
        dnsutils \
		gcc \
        jq \
# Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user.
    && groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # [Optional] Add sudo support
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /tmp/gotools

COPY --chown=1000:1000 --from=hobord/golang-dev /golang /golang

# Update this to "on" or "off" as appropriate
ENV GO111MODULE=auto

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog
