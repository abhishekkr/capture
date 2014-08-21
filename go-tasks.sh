#!/bin/bash


# managing project only goenvs
goenv_on(){
  if [ $# -eq 0 ]; then
    _GOPATH_VALUE="${PWD}/.goenv"
  else
    cd $1 ; _GOPATH_VALUE="${PWD}/.goenv" ; cd -
  fi
  if [ ! -d $_GOPATH_VALUE ]; then
    mkdir -p "${_GOPATH_VALUE}/site"
  fi
  export _OLD_GOPATH=$GOPATH
  export _OLD_PATH=$PATH
  export GOPATH=$_GOPATH_VALUE/site
  export PATH=$PATH:$GOPATH/bin
}
alias goenv_off="export GOPATH=$_OLD_GOPATH ; export PATH=$_OLD_PATH ; unset _OLD_PATH ; unset _OLD_GOPATH"


# managing go deps
go_get_pkg(){
  if [ $# -eq 0 ]; then
    if [ -f "$PWD/go-get-pkg.txt" ]; then
      PKG_LISTS="$PWD/go-get-pkg.txt"
    else
      touch "$PWD/go-get-pkg.txt"
      echo "Created GoLang Package empty list $PWD/go-get-pkg.txt"
      echo "Start adding package paths as separate lines." && return 0
    fi
  else
    PKG_LISTS=($@)
  fi
  for pkg_list in $PKG_LISTS; do
    cat $pkg_list | while read pkg_path; do
      echo "fetching golang package: go get ${pkg_path}";
      echo $pkg_path | xargs go get
    done
  done
}


_OLD_PWD=$PWD
cd $(dirname $0)
  goenv_on

if [[ $# -ne 1 ]]; then
  echo "Use it wisely..."
  echo "Install tall Go lib dependencies: '$0 deps'"
  echo "Create binary: '$0 bin'"
  exit 1

elif [[ "$1" == "deps" ]]; then
  go_get_pkg

elif [[ "$1" == "test" ]]; then
  echo "To Be Done." ; exit 1
  $0 bin
  echo
  echo "~~~~~Test Pieces~~~~~"
  go test ./...

elif [[ "$1" == "bin" ]]; then
  bash $0 deps
  mkdir -p ./bin
  cd ./bin
  for go_code_to_build in `ls ../capture*.go`; do
    go build $go_code_to_build
  done

elif [[ "$1" == "run" ]]; then
  bash $0 bin
  ./bin/capture

fi

cd $_OLD_PWD
