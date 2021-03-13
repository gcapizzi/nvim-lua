# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/groovy64"
  config.vm.provision "shell", inline: <<-SHELL
    add-apt-repository ppa:neovim-ppa/unstable
    apt-get update
    apt-get install -y neovim ripgrep

    wget https://golang.org/dl/go1.16.2.linux-amd64.tar.gz
    rm -rf /usr/local/go && tar -C /usr/local -xzf go1.16.2.linux-amd64.tar.gz
    rm -f go1.16.2.linux-amd64.tar.gz
  SHELL
  config.vm.provision "shell" do |p|
    p.privileged = false
    p.inline = <<-SHELL
      echo 'export PATH="$PATH:/usr/local/go/bin:$HOME/go/bin"' >> "$HOME/.profile"
      GO111MODULE=on go get golang.org/x/tools/gopls@latest

      mkdir -p "$HOME/.config/nvim"
      ln -s /vagrant/init.lua "$HOME/.config/nvim/init.lua"
      nvim +PackerSync +qall
    SHELL
  end
end
