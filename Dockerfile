FROM ubuntu:focal
ENV DEBIAN_FRONTEND=noninteractive
ARG GO_VERSION=1.16
ENV GO_VERSION=$GO_VERSION \
    GOOS=linux \
    GOARCH=amd64 \
    GOROOT=/golang/go \
    GOPATH=/golang/go-tools
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH

WORKDIR /tmp/
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
    && apt-get -y install \
		gcc \
        ca-certificates \
        git \
        lsb-release \
        curl \
        jq \
        unzip \
		make \
		# Clean up
    && apt-get autoremove -y \
    && apt-get clean -y

# install Go
RUN mkdir -p /golang \
    #
    && curl -fsSL https://golang.org/dl/go$GO_VERSION.$GOOS-$GOARCH.tar.gz | tar -C /golang -xzv
RUN go get golang.org/x/tools/gopls \
        #        && go get -u honnef.co/go/tools \
    && GO111MODULE=on go get -v \
         golang.org/x/tools/cmd/goimports@latest \
         golang.org/x/tools/cmd/guru@latest \
         github.com/mdempsky/gocode@latest \
         honnef.co/go/tools/...@latest \
         github.com/cweill/gotests/...@latest \
         github.com/haya14busa/goplay/cmd/goplay@latest \
         github.com/sqs/goreturns@latest \
         github.com/josharian/impl@latest \
         github.com/davidrjenni/reftools/cmd/fillstruct@latest \
         github.com/ramya-rao-a/go-outline@latest  \
         github.com/acroca/go-symbols@latest  \
         github.com/godoctor/godoctor@latest  \
         github.com/rogpeppe/godef@latest  \
         github.com/zmb3/gogetdoc@latest \
         github.com/fatih/gomodifytags@latest \
         github.com/jstemmer/gotags@latest \
         github.com/mgechev/revive@latest  \
         github.com/vektra/mockery/v2/.../ \
         cuelang.org/go/cmd/cue \
         cuelang.org/go/cue \
         github.com/axw/gocov/... \
         github.com/AlekSi/gocov-xml 2>&1 \
    && GO111MODULE=off go get github.com/uudashr/gopkgs/v2/cmd/gopkgs 2>&1 \
    && go get github.com/go-delve/delve/cmd/dlv 2>&1 \
    #
    # Install gocode-gomod
    && go get -u github.com/stamblerre/gocode 2>&1 \
    #
    # Install golangci-lint
    && curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin 2>&1 \
    #
    # Install protoc
    && LATEST_PROTOC=`curl -s https://api.github.com/repos/protocolbuffers/protobuf/releases/latest | jq -r ".assets[] | select(.name | test(\"${spruce_type}\")) | .browser_download_url" | grep linux-x86_64.zip` \
    && curl -L -o protoc.zip $LATEST_PROTOC \
    && unzip protoc.zip -d protoc \
    && mv protoc/bin/protoc $GOPATH/bin/protoc \
    #
    # Install grpc
    && GO111MODULE=on go get -u google.golang.org/grpc github.com/golang/protobuf/protoc-gen-go \
    #
    && go get github.com/twitchtv/twirp/protoc-gen-twirp \
    # Cleanup
    && rm -Rf /tmp/*

### FINAL ENV

ENV DEBIAN_FRONTEND=dialog
ENV SHELL=/bin/bash

