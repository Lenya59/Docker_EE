# Docker_EE

##### Hello!
Here you can see small docker-swarm project. It will deploy the application as Docker stack app in the Docker Swarm cluster.
####  Little overview
Our infrastructure consist of 3 nodes:
* jenkinsmaster - main place for Jenkins jobs runs.
* swarmmaster - is a jenkinsmaster's slave, where job will run and MASTER NODE of the Docker Swarm cluster. It includes installed Docker Enterprise Edition with Docker Swarm, Docker Compose, Universal Control Plane(UCP) and Docker Trusted Registry(DTR).
* swarmslave1 - is a WORKER NODE of the Docker Swarm cluster. It includes installed Docker Enterprise Edition with Docker Swarm and Docker Compose

For building our vitual infrastracture I use virtualbox and vagrant. So, let's get started

# Vagrant
First of all, let's run vagrant init command line tool to create Vagrantfile. Vagrantfile is a ruby file used to configure CPU, Memory, Network, OS and so on for VirtualBox creation.
![vagrant-init](https://user-images.githubusercontent.com/30426958/56807807-7ad8da00-6838-11e9-86f2-ee79e1368a08.png)

Ok, the above output shows that Vagrantfile is successfully created. Let's edit vagrantfile for our infrastructure. You can find edited Vagrantfile in this GitHub repository. Also, you need to create jenkins_install.sh and docker_install.sh files, which is needed to install the necessary tools on our nodes.

![vagrantfile](https://user-images.githubusercontent.com/30426958/56863601-1ac16f80-69c1-11e9-9f71-71503067c245.png)

The above file picture describes our infrastructure. I used centros\7 for jenkinsmaster node and ubuntu for swarmmaster  and swarmslave1 node. A quick note: to access the network, you need to use a public network and specify the name of your network adapter
