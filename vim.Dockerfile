FROM ubuntu:focal as vim
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /tmp

RUN apt-get update \
    && apt-get remove vim vim-runtime vim-tiny vim-common \
    && apt-get -y install git libncurses5-dev python-dev liblua5.3-dev lua5.3 python3-dev make

RUN git clone https://github.com/vim/vim.git

WORKDIR /tmp/vim
RUN ./configure \
	--enable-luainterp \
	--enable-python3interp \
	--with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu/ \
	--enable-cscope \
	--disable-netbeans \
	--enable-terminal \
	--disable-xsmp \
	--enable-fontset \
	--enable-multibyte \
	--enable-fail-if-missing \
    && make VIMRUNTIMEDIR=/usr/local/share/vim/vim82 \
    && make install


FROM ubuntu:focal
ENV DEBIAN_FRONTEND=noninteractive
ARG GO_VERSION=1.14.4
ARG USER_UID=1000
ARG USER_GID=${USER_UID}
ENV GO_VERSION=$GO_VERSION \
    GOOS=linux \
    GOARCH=amd64 \
    GOROOT=/golang/go \
    GOPATH=/golang/go-tools
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH
ENV USERNAME=gropher

# VIM
COPY --from=vim /usr/local /usr/local

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
		tmux \
    && update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1 \
    && update-alternatives --set editor /usr/local/bin/vim \
    && update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 1 \
    && update-alternatives --set vi /usr/local/bin/vim \
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
RUN curl -fLo /home/${USERNAME}/.vim/autoload/plug.vim --create-dirs http://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    && vim +PlugInstall +qall 2> /dev/null 1>/dev/null 

WORKDIR /workspace
# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog
ENV SHELL=/bin/bash
ENV TERM xterm-256color

EXPOSE 80 3000 8080 9090 50050 50051
ENTRYPOINT [ "bash" ]
