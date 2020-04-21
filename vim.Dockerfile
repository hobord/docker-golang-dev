FROM ubuntu:focal
ENV DEBIAN_FRONTEND=noninteractive
ARG GO_VERSION=1.14.1
ARG USER_GID=1000
ARG USER_UID=1000
ENV GO_VERSION=$GO_VERSION \
    GOOS=linux \
    GOARCH=amd64 \
    GOROOT=/golang/go \
    GOPATH=/golang/go-tools
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH
ENV USERNAME=gropher

# install Go
WORKDIR /tmp/
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils dialog vim 2>&1 \
    && apt-get -y install \
        git \
        iproute2 \
        procps \
        lsb-release \
        curl \
        netcat \
        telnet \
        dnsutils \
        jq \
        unzip \
        ssh \
        sudo \
        # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME} \
    && chmod g+rw /home
COPY --chown=${USER_UID}:${USER_GID} --from=hobord/golang-dev /golang /golang

RUN chown -R ${USERNAME}:${USERNAME} /golang \
    && mkdir -p /workspace \
    && chown -R ${USERNAME}:${USERNAME} /workspace

# VIM
USER ${USERNAME} 
COPY --chown=${USER_UID}:${USER_GID} profile /home/${USERNAME}
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    && vim +PlugInstall +qall 2> /dev/null 1>/dev/null

WORKDIR /workspace
# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog
ENV SHELL=/bin/bash

EXPOSE 80 3000 8080 9090 50050 50051
ENTRYPOINT [ "bash" ]