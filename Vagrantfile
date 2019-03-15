# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-16.04"
  config.vm.network "forwarded_port", guest: 8000, host: 8000

  # config.vm.provider "virtualbox" do |vb|
  #   vb.gui = true
  #   vb.customize ["modifyvm", :id, "--memory", 4096]
  #   vb.customize ["modifyvm", :id, "--cpus", 2]
  #   vb.customize ["modifyvm", :id, "--vram", "256"]
  #   vb.customize ["modifyvm", :id, "--ioapic", "on"]
  #   vb.customize ["modifyvm", :id, "--rtcuseutc", "on"]
  #   vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
  #   vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
  #   vb.customize ["setextradata", "global", "GUI/MaxGuestResolution", "any"]
  #   vb.customize ["setextradata", :id, "CustomVideoMode1", "1024x768x32"]
  # end

  config.vm.provision "shell", inline: <<-SHELL
    sed -i 's,archive.ubuntu.com,ubuntutym.u-toyama.ac.jp,g' /etc/apt/sources.list
    apt-get update

    apt-get install -y \
      build-essential \
      libbz2-dev \
      libdb-dev \
      libreadline-dev \
      libffi-dev \
      libgdbm-dev \
      liblzma-dev \
      libncursesw5-dev \
      libreadline-dev \
      libsqlite3-dev \
      libssl-dev \
      zlib1g-dev \
      uuid-dev \
      tk-dev
  SHELL

  config.vm.provision "pyenv", type: "shell", privileged: false, inline: <<-SHELL
    if [[ ! -d ~/.pyenv ]]; then
      git clone https://github.com/pyenv/pyenv.git ~/.pyenv

      echo 'export PYENV_ROOT="${HOME}/.pyenv"' >> ~/.bashrc
      echo 'export PATH="${PYENV_ROOT}/bin:${PATH}"' >> ~/.bashrc
      echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bashrc

      PATH="${HOME}/.pyenv/bin:${PATH}"
      PYTHON_VERSION="3.7.2"
      CONFIGURE_OPTS="--enable-shared"

      eval "$(pyenv init -)"
      pyenv install ${PYTHON_VERSION}
      pyenv global ${PYTHON_VERSION}

      pip install -U pip pipenv
    fi
  SHELL
end
