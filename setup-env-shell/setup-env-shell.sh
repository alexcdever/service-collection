#!/bin/bash
# apt
apt() {
  installBasicApps
}
## update & upgrade apt package
installBasicApps() {
  echo "---START TO INSTALL THE BASIC APPS---"
  sudo apt update && sudo apt upgrade -y
  sudo apt install curl git vim -y
  echo "---FINISH TO INSTALL THE BASIC APPS---"
}

# zsh
zsh() {
  echo "---START TO INSTALL ZSH---"
  if [ "$(echo $SHELL | grep "zsh")" ]; then
    echo "You are using zsh"
  else
    changeToZsh
    installOhMyZsh
    installZshPlugins
  fi
  echo "---CHANGE TO ZSH---"
}
## change the shell to zsh
changeToZsh() {

  if [ "$(which zsh | grep "zsh")" ]; then
    echo "Zsh already existed"
  else
    sudo apt install zsh -y
  fi
  sudo chsh -s "$(command -v zsh)"
}
## install oh-my-zsh
installOhMyZsh() {
  echo "---START TO INSTALL OH-MY-ZSH---"
  if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "OH-MY-ZSH already installed"
  else
    sudo zsh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
  fi

}

## install the zsh plugins, such as autosuggestion and syntax-hightlight
installZshPlugins() {
  echo "---START TO INSTALL THE PLUGINS OF ZSH---"
  pluginPath="$ZSH_CUSTOM/plugins"
  suggestion="zsh-autosuggestions"
  hightlight="zsh-syntax-highlighting"
  newPlugins=("$suggestion" "$hightlight")
  echo "The plugins as below will be installed: ${newPlugins[*]}"

  for plugin in ${newPlugins[*]}; do
    if [ -d "$pluginPath/$plugin" ]; then
      echo "Plugin[$plugin] already existed"
    else
      git clone git://github.com/zsh-users/$plugin
    fi
  done

  source "$HOME/.zshrc"

  echo "Original plugins count: ${#plugins[*]} "
  if [ "${#plugins[*]}" -gt 0 ]; then
    echo "Merge \"${plugins[@]}\" and \"${newPlugins[@]}\""
    plugins=(${plugins[*]} ${newPlugins[*]})
  else
    echo "Set up the plugins as ${newPlugins[@]} "
    plugins=$newPlugins
  fi

  echo "Now this plugins are installed: ${plugins[@]}, please remove the Repeated elements and update the 'plugins' array of '$HOME/.zshrc' manually"

  echo "---FINISH TO INSTALL ZSH PLUGINS---"
}

# linuxbrew
linuxbrew() {
  echo "---START TO INSTALL LINUXBREW---"
  if [ "$(which brew)" ]; then
    echo "Linuxbrew already installed"
  else
    echo "installing linuxbrew"
    installLinuxbrew $1
  fi
  echo "---FINISH TO INSTALL LINUXBREW---"
}
## install linuxbrew
installLinuxbrew() {
  executer=$1
  if [ $executer != $USER ]; then
    echo "execute user is $executer, but now is $USER"
    exit
  fi
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
  test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  test -r ~/.zshrc && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.zshrc
  echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.zshrc

}

# sdkman
sdkman() {
  echo "---START TO INSTALL SDKMAN---"
  if [ "$(sdk info)" ]; then
    echo "Sdkman already installed"
  else
    installSdkman
  fi
  echo "---FINISH TO INSTALL SDKMAN---"
}
## install sdkman
installSdkman() {
  curl -s "https://get.sdkman.io" | bash
  source "$HOME/.sdkman/bin/sdkman-init.sh"
  source ~/.zshrc
}

# docker
docker() {
  if [ "$(docker info)" ]; then
    echo "docker already installed"
  else
    installDocker
  fi

  if [ "$(docker-compose info)" ]; then
    echo "docker-compose already installed"
  else
    installDockerCompose
  fi
}
## install docker
installDocker() {
  echo "---START TO INSTALL DOCKER---"

  sudo apt remove docker docker-engine docker.io containerd runc -y

  sudo apt-get update

  sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common

  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

  sudo apt-key fingerprint 0EBFCD88

  sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

  sudo apt-get update

  sudo apt-get install docker-ce docker-ce-cli containerd.io -y

  echo "---FINISH TO INSTALL DOCKER---"
}

## install docker-compose
installDockerCompose() {
  echo "---START TO INSTALL DOCKER-COMPOSE---"
  sudo curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  docker-compose --version

  echo "---FINISH TO INSTALL DOCKER-COMPOSE---"
}

#apt
#zsh
linuxbrew $USER
