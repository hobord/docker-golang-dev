GOLANG-DEV
==

Golang development environment with tools for multistage build.

ARG GO_VERSION=1.14.1

path:

```
/golang
    /go
    /go-tools
```

tools:
- ast-to-pattern
- dlv
- fillstruct
- go-module-query
- go-outline
- go-symbols
- gocode
- gocode-gomod
- godef
- godoctor
- gogetdoc
- gogrep
- goimports
- golangci-lint
- golint
- gometalinter
- gomodifytags
- gopkgs
- goplay
- gopls
- gorename
- goreturns
- gosmith
- gotests
- guru
- impl
- irdump
- keyify
- protoc
- protoc-gen-go
- rdeps
- revive
- staticcheck
- structlayout
- structlayout-optimize
- structlayout-pretty





## vim
```
docker run -it --rm hobord/golang-dev:vim
```

Cheatsheet
###
```
:GoRun :GoBuild :GoInstall   

:GoDef          # goto definition of object under cursor   
gd              # also has the same effect
Ctrl-O / Ctrl-I # hop back to your source file/return to definition

:GoDoc          # opens up a side window for quick documentationn   
K               # also has the same effect

   
:GoTest         # run every *_test.go file and report results   
:GoTestFunc     # or just test the function under your cursor   
:GoCoverage     # check your test coverage   
:GoAlternate	# switch bewteen your test case and implementation   

:GoImport       # manage and name your imports   
:GoImportAs   
:GoDrop   
   
:GoRename       # precise renaming of identifiers   
   
:GoLint         # lint your code   
:GoVer   
:GoErrCheck   
   
:GoAddTags      # manage your tags   
:GoRemoveTags  

<C-g>           # toogle nerdtree
```