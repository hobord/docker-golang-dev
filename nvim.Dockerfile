FROM ubuntu:focal
ENV DEBIAN_FRONTEND=noninteractive
ARG GO_VERSION=1.15.3
ARG USER_UID=1000
ARG USER_GID=${USER_UID}
ENV GO_VERSION=$GO_VERSION \
    GOOS=linux \
    GOARCH=amd64 \
    GOROOT=/golang/go \
    GOPATH=/golang/go-tools
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH
ENV USERNAME=gropher

ENV PATH=$PATH:/opt/nvim/bin/

WORKDIR /tmp/
RUN apt-get update \
    && apt-get remove vim vim-runtime vim-tiny vim-common \
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
    && apt-get -y install --no-install-recommends \
        ca-certificates \
        iblua5.3-0 \
        libpython3.8 \
        git \
		make \
		cmake \
		gcc \
        iproute2 \
        telnet \
        iputils-ping \
        curl \
		ctags \
        netcat \
        dnsutils \
        procps \
        lsb-release \
        jq \
        unzip \
        ssh \
        sudo \
        ranger \
		fzf \
		tmux \
		nodejs \
		npm \
		#    && update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1 \
		#&& update-alternatives --set editor /usr/local/bin/vim \
		#&& update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 1 \
		#&& update-alternatives --set vi /usr/local/bin/vim \
	&& curl -L -o nvim.tgz https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz \
	&& tar -xvvf ./nvim.tgz \
	&& mv nvim-linux64 /opt/nvim \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    # Add sudoers user    
    && groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME} \
    && chmod g+rw /home \
    && mkdir -p /workspace \
    && chown -R ${USERNAME}:${USERNAME} /workspace

# install Go
COPY --chown=1000:1000 --from=hobord/golang-dev /golang /golang

# create user profile
USER ${USERNAME} 
COPY --chown=1000:1000 profile /home/${USERNAME}
RUN curl -fLo /home/${USERNAME}/.config/nvim/autoload/plug.vim --create-dirs http://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    && nvim +PlugInstall +qall 2> /dev/null 1>/dev/null; exit 0 

WORKDIR /workspace
# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog
ENV SHELL=/bin/bash
ENV TERM xterm-256color

EXPOSE 80 3000 8080 9090 50050 50051
ENTRYPOINT [ "bash" ]
