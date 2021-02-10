FROM hobord/nvim

ENV DEBIAN_FRONTEND=noninteractive
ARG GO_VERSION=1.15.6
ARG USER_UID=1000
ARG USER_GID=${USER_UID}
ENV GO_VERSION=$GO_VERSION \
    GOOS=linux \
    GOARCH=amd64 \
    GOROOT=/golang/go \
    GOPATH=/golang/go-tools
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH
ENV USERNAME=gropher

WORKDIR /tmp/
RUN apt-get update \
    && apt-get remove vim vim-runtime vim-tiny vim-common \
    && apt-get -y install --no-install-recommends \
	make \
		cmake \
        iproute2 \
        telnet \
        iputils-ping \
        netcat \
        dnsutils \
        procps \
        jq \
        ssh \
        sudo \
        ranger \
		tmux \
		nodejs \
		npm \
		#    && update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1 \
		#&& update-alternatives --set editor /usr/local/bin/vim \
		#&& update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 1 \
		#&& update-alternatives --set vi /usr/local/bin/vim \
    && apt-get autoremove -y \
    && apt-get clean -y \
    # Add sudoers user    
    && groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME} \
    && cp -a /root/.config /home/${USERNAME}/ \
    && chown -R $USER_UID:$USER_GID /home/${USERNAME} \
    && chmod g+rw /home \
    && mkdir -p /workspace \
    && chown -R ${USERNAME}:${USERNAME} /workspace

# install Go
COPY --chown=1000:1000 --from=hobord/golang-dev /golang /golang

# create user profile
USER ${USERNAME} 

WORKDIR /workspace
# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog
ENV SHELL=/bin/zsh
ENV TERM xterm-256color

EXPOSE 80 3000 8080 9090 50050 50051
ENTRYPOINT [ "zsh" ]
