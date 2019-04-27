hosts = [
  { name: 'jenkinsmaster',   box: 'centos/7',       	mem: 512, 	netint: 1 },
  { name: 'swarmmaster',     box: 'ubuntu/trusty64',	mem: 512,	  netint: 2 },
  { name: 'swarmslave1',     box: 'ubuntu/xenial64',	mem: 512,	  netint: 3 }
]


Vagrant.configure('2') do |config|
  hosts.each do |host|
    config.vm.define host[:name] do |node|
      node.vm.box = host[:box]
      node.vm.hostname = host[:name]
      node.vm.provider :virtualbox do |vm|
        vm.memory = host[:mem]
      end


      if host[:netint] == 1
        node.vm.network :public_network, bridge: 'RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller'
        node.vm.provision 'shell', path: 'jenkins_install.sh'
#        config.vm.network "forwarded_port", guest: 8080, host: 8080
      end

      if host[:netint] == 2
        node.vm.network :public_network, bridge: 'RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller'
        node.vm.provision 'shell', path: 'docker_install.sh'
      end

      if host[:netint] == 3
        node.vm.network :public_network, bridge: 'RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller'
        node.vm.provision 'shell', path: 'docker_install.sh'
      end

    end
    config.vm.synced_folder '.', '/vagrant', type: 'virtualbox'
    Vagrant::Config.run do |config|
      config.vbguest.auto_update = false
      config.vbguest.no_remote = true
    end
  end
end
