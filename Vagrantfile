# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/groovy64"
  config.vm.provision "shell", inline: <<-SHELL
    add-apt-repository ppa:neovim-ppa/unstable
    apt-get update
    apt-get install -y neovim ripgrep
  SHELL
  config.vm.provision "shell" do |p|
    p.privileged = false
    p.inline = <<-SHELL
      mkdir -p "$HOME/.config/nvim"
      ln -s /vagrant/init.lua "$HOME/.config/nvim/init.lua"
      nvim +PackerSync +qall
    SHELL
  end
end
