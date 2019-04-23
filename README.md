# docker-swarm-infrastructure

##### Hello!
Here you can see small docker-swarm project. It will deploy the application as Docker stack app in the Docker Swarm cluster.
######  little overview
Our infrastructure consist of 3 nodes: jenkinsmaster, swarmmaster, swarmslave1.
* jenkinsmaster - main place for Jenkins jobs runs.
* swarmmaster - is a jenkinsmaster's slave, where job will run and MASTER NODE of the Docker Swarm cluster. It includes installed Docker Enterprise Edition with Docker Swarm, Docker Compose, Universal Control Plane(UCP) and Docker Trusted Registry(DTR).
* swarmslave1 - is a WORKER NODE of the Docker Swarm cluster. It includes installed Docker Enterprise Edition with Docker Swarm and Docker Compose

For building our vitual infrastracture I use virtualbox and vagrant. So, let's get started
