hosts = [
  { name: 'jenkinsmaster',   box: 'ubuntu/trusty64',	mem: 512, 	netint: 1 },
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
        node.vm.network "private_network", ip: "192.168.10.11"
        node.vm.provision 'shell', path: 'jenkins_install.sh'
        config.vm.network "forwarded_port", guest: 8080, host: 8080
      end

      if host[:netint] == 2
        node.vm.vm.network "private_network", ip: "192.168.10.12"
        node.vm.provision 'shell', path: 'docker_install.sh'
      end

      if host[:netint] == 3
        node.vm.network "private_network", ip: "192.168.10.13"
        node.vm.provision 'shell', path: 'docker_install.sh'
      end
    end
  end
end
