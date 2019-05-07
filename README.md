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

![vagrantfile](https://user-images.githubusercontent.com/30426958/56931166-c9f86680-6ae7-11e9-9a4b-e6f8b91eb83b.png)

The above file picture describes our infrastructure. I used centros\7 for jenkinsmaster node and ubuntu for swarmmaster  and swarmslave1 node. 
**A useful note:** to access the network, you need to use a public network and specify the name of your network adapter
### Tools
Go on, let's check our nodes for the necessary tools. The first node has installed Jenkins. You can see this in the console output presented below
![jenkinsmaster_bootstrap](https://user-images.githubusercontent.com/30426958/56929175-a03c4100-6ae1-11e9-9c8c-f52a42a27f44.png)

You will get next console output after start up node swarmmaster. Also, it would be the same on swarmslave node.

![swarmmaster_bootstrap](https://user-images.githubusercontent.com/30426958/56930708-56a22500-6ae6-11e9-8fc5-244fd028d8fe.png)

#### UCP and DTR
Next step is to install UCP and DTR on our swarmmaster node. More much interesting information you can find [here](https://docs.docker.com/ee/ucp/admin/install/ "Universal Control Plane"), and [here](https://docs.docker.com/ee/dtr/admin/install/ "Docker Trusted Registry")

###### UCP
```shell
# Pull the latest version of UCP
docker image pull docker/ucp:3.1.6

# Install UCP
docker container run --rm -it --name ucp \
  -v /var/run/docker.sock:/var/run/docker.sock \
  docker/ucp:3.1.6 install \
  --force-minimums \
  --interactive \
  --pod-cidr 192.168.0.0/16  \
  ```
  **A useful note:** if your local networks intersect with the docker's networks, you need to use the --pod-cidr option, more information about it you will find [here](https://docs.docker.com/reference/ucp/3.1/cli/install/ "Options")

---
```shell
Confirm Admin Password:
INFO[0014] Pulling required images... (this may take a while)
INFO[0014] Pulling docker/ucp-auth:2.2.4
INFO[0018] Pulling docker/ucp-hrm:2.2.4
INFO[0022] Pulling docker/ucp-controller:2.2.4
INFO[0030] Pulling docker/ucp-swarm:2.2.4
INFO[0034] Pulling docker/ucp-etcd:2.2.4
INFO[0043] Pulling docker/ucp-agent:2.2.4
INFO[0048] Pulling docker/ucp-compose:2.2.4
INFO[0054] Pulling docker/ucp-metrics:2.2.4
INFO[0062] Pulling docker/ucp-dsinfo:2.2.4
INFO[0102] Pulling docker/ucp-cfssl:2.2.4
INFO[0107] Pulling docker/ucp-auth-store:2.2.4
WARN[0114] None of the hostnames we'll be using in the UCP certificates [swarmmaster 127.0.0.1 172.17.0.1 192.168.104.69] contain a domain component.  Your generated certs may fail TLS validation unless you only use one of these shortnames or IPs to connect.  You can use the --san flag to add more aliases

You may enter additional aliases (SANs) now or press enter to proceed with the above list.
Additional aliases:
INFO[0000] Initializing a new swarm at 192.168.104.69
INFO[0010] Establishing mutual Cluster Root CA with Swarm
INFO[0013] Installing UCP with host address 192.168.104.69 - If this is incorrect, please specify an alternative address with the '--host-address' flag
INFO[0013] Generating UCP Client Root CA
INFO[0013] Deploying UCP Service
INFO[0050] Installation completed on swarmmaster (node z4kky1uuf3uhgkmwot9u90f87)
INFO[0050] UCP Instance ID: luzhqotsl7awa1l5hbk4lnwcc
INFO[0050] UCP Server SSL: SHA-256 Fingerprint=88:AA:A7:38:0A:56:DD:D4:0F:ED:96:21:77:61:8C:46:18:DC:73:A7:3A:FF:F3:13:16:6D:C5:12:BD:A5:66:AE
INFO[0050] Login to UCP at https://192.168.104.69:443
INFO[0050] Username: leshik59
INFO[0050] Password: (your admin password)
```
![login_UCP](https://user-images.githubusercontent.com/30426958/57230077-314e7300-7020-11e9-921f-b6214e5e7fa2.png)

![UCP](https://user-images.githubusercontent.com/30426958/57230095-3c090800-7020-11e9-9df1-488e41d8c4d6.png)


Next step is installing DTR
 ```shell
docker run -it --rm docker/dtr install  --ucp-node swarmmaster  --ucp-username leshik59  --ucp-url http://swarmmaster:1443  --ucp-insecure-tls
 ```
  ```shell
 INFO[0000] Beginning Docker Trusted Registry installation
ucp-password:
INFO[0002] Validating UCP cert
INFO[0003] health checking ucp
INFO[0003] The UCP cluster contains the following nodes without port conflicts: swarmslave1, swarmmaster
INFO[0003] Searching containers in UCP for DTR replicas
INFO[0003] Searching containers in UCP for DTR replicas
INFO[0003] verifying [80 443] ports on swarmmaster
INFO[0007] Waiting for running dtr-phase2 container to finish
INFO[0007] starting phase 2
INFO[0000] Validating UCP cert
INFO[0000] Connecting to UCP
INFO[0000] health checking ucp
INFO[0000] Verifying your system is compatible with DTR
INFO[0000] Checking if the node is okay to install on
WARN[0000] Node: swarmmaster is a manager, it is **not** recommended for DTR to reside on a UCP manager node, see: https://docs.docker.com/ee/dtr/admin/install/system-requirements/ for more info.
WARN[0000] Installation will continue in 10 seconds...
INFO[0010] Using default overlay subnet: 10.1.0.0/24
INFO[0010] Creating network: dtr-ol
INFO[0010] Connecting to network: dtr-ol
INFO[0010] Waiting for phase2 container to be known to the Docker daemon
INFO[0011] Setting up replica volumes...
INFO[0012] Creating initial CA certificates
INFO[0012] Bootstrapping rethink...
INFO[0012] Creating dtr-rethinkdb-f82fa9375f55...
INFO[0022] Establishing connection with Rethinkdb
INFO[0023] Waiting for database dtr2 to exist
INFO[0023] Establishing connection with Rethinkdb
INFO[0023] Generated TLS certificate.                    dnsNames="[*.com *.*.com example.com *.dtr *.*.dtr]" domains="[*.com *.*.com 172.17.0.1 example.com *.dtr *.*.dtr]" ipAddresses="[172.17.0.1]"
INFO[0023] License config copied from UCP.
INFO[0023] Migrating db...
INFO[0000] Establishing connection with Rethinkdb
INFO[0000] Migrating database schema                     fromVersion=0 toVersion=10
INFO[0001] Waiting for database notaryserver to exist
INFO[0002] Waiting for database notarysigner to exist
INFO[0002] Waiting for database jobrunner to exist
INFO[0003] Migrated database from version 0 to 10
INFO[0027] Starting all containers...
INFO[0027] Getting container configuration and starting containers...
INFO[0027] Automatically configuring rethinkdb cache size to 2000 mb
INFO[0028] Recreating dtr-rethinkdb-f82fa9375f55...
INFO[0032] Creating dtr-registry-f82fa9375f55...
INFO[0041] Creating dtr-garant-f82fa9375f55...
INFO[0049] Creating dtr-api-f82fa9375f55...
INFO[0058] Creating dtr-notary-server-f82fa9375f55...
INFO[0067] Recreating dtr-nginx-f82fa9375f55...
INFO[0077] Creating dtr-jobrunner-f82fa9375f55...
INFO[0120] Creating dtr-notary-signer-f82fa9375f55...
INFO[0130] Creating dtr-scanningstore-f82fa9375f55...
INFO[0142] Trying to get the kv store connection back after reconfigure
INFO[0142] Establishing connection with Rethinkdb
INFO[0142] Verifying auth settings...
INFO[0143] Successfully registered dtr with UCP
INFO[0143] Installation is complete
INFO[0143] Replica ID is set to: f82fa9375f55
INFO[0143] You can use flag '--existing-replica-id f82fa9375f55' when joining other replicas to your Docker Trusted Registry Cluster
 ```

---
 
 # Cluster
 
 ## Add ssh-slave node 
 
 Next step is adding swarmmaster as jenkinsmaster slave via ssh. Before adding a slave, you need to install Java on it.
 ```shell
 sudo apt-get update
 sudo apt-get install openjdk-8-jdk
  ```
  
Let's go to slave and create private and public SSH keys. The following command creates the private key 'The access key for Jenkins slaves' for accec to slave via ssh
```shell
sudo adduser jenkins --shell /bin/bashssh-keygen

su jenkins

mkdir /home/jenkins/jenkins_slave

mkdir ~/.ssh && cd ~/.ssh


ssh-keygen -t rsa -C "The access key for Jenkins slaves"

cat id_rsa.pub > ~/.ssh/authorized_keys

cat id_rsa

```
 
![image](https://user-images.githubusercontent.com/30426958/57023749-86167600-6c3b-11e9-8ead-bd7ff09a4c5c.png)

Well done. Now you can add a node to Jenkins. Go to Manage Jenkins - Manage Nodes - New Node. Specify the name and set - Permanent agent. Then home user jenkins - home/vagrant. Launch method - select Launch slave agents via SSH. Host - specify the hostname of the slave node and credits - click Add. Kind - specify SSH username with private key

Congratulations!! Now you have your slave node for doing your jobs))

![ssh-slave](https://user-images.githubusercontent.com/30426958/57112400-80f31d00-6d48-11e9-896c-6d29aa6c98cb.png)
[tip](https://devopscube.com/setup-slaves-on-jenkins-2/ "ssh-agent-setup")
## Swarm-cluster

Initialization of docker swarm cluster:

![swarm_init](https://user-images.githubusercontent.com/30426958/56969044-0621da80-6b6d-11e9-890c-7ddcda010b04.png)

Also you can use this command to generate token for worker node
```shell
docker swarm join-token worker
```
![join_token](https://user-images.githubusercontent.com/30426958/57021687-9cb9ce80-6c35-11e9-8801-4a4a8bfbd9dc.png)

Add slave node for docker swarm cluster

![swarmslave_join](https://user-images.githubusercontent.com/30426958/56969151-3bc6c380-6b6d-11e9-9e09-cb25d0302984.png)

# Deploy
Let's adopt that we have all needful for deoploying application and proceed to this step.
Next option is creating a Maven builder in the Jenkins because [deployed application](https://github.com/sqshq/PiggyMetrics "piggymetriks") is being built by Maven builder.

Let's create jenkins job which will deploy our application

Source code management:

![image](https://user-images.githubusercontent.com/30426958/57298802-b64a9280-70db-11e9-8a1b-06161b618386.png)

Also you should chose build options

![image](https://user-images.githubusercontent.com/30426958/57299679-d8451480-70dd-11e9-8cbd-674738ed7a63.png)



```shell
Started by user admin
[EnvInject] - Loading node environment variables.
Building remotely on ssh-slave (xenial) in workspace /var/lib/jenkins/workspace/Piggy
using credential c1377648-be66-4676-9fbd-a5fdf0bc67ce
 > git rev-parse --is-inside-work-tree # timeout=10
Fetching changes from the remote Git repository
 > git config remote.origin.url https://github.com/sqshq/piggymetrics.git # timeout=10
Fetching upstream changes from https://github.com/sqshq/piggymetrics.git
 > git --version # timeout=10
using GIT_ASKPASS to set credentials GitHub
 > git fetch --tags --progress https://github.com/sqshq/piggymetrics.git +refs/heads/*:refs/remotes/origin/*
 > git rev-parse refs/remotes/origin/master^{commit} # timeout=10
 > git rev-parse refs/remotes/origin/origin/master^{commit} # timeout=10
Checking out Revision 20237e62b4305dc888aa55b61e1e103fbd3856bf (refs/remotes/origin/master)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 20237e62b4305dc888aa55b61e1e103fbd3856bf
Commit message: "Merge pull request #48 from zuzhi/master"
 > git rev-list --no-walk 20237e62b4305dc888aa55b61e1e103fbd3856bf # timeout=10
[Piggy] $ /bin/sh -xe /tmp/jenkins6828677510483824087.sh
+ export CONFIG_SERVICE_PASSWORD
+ export NOTIFICATION_SERVICE_PASSWORD
+ export STATISTICS_SERVICE_PASSWORD
+ export ACCOUNT_SERVICE_PASSWORD
+ export MONGODB_PASSWORD
[Piggy] $ /var/lib/jenkins/tools/hudson.tasks.Maven_MavenInstallation/Maven_test_3.5.3/bin/mvn compile
[INFO] Scanning for projects...
[INFO] ------------------------------------------------------------------------
[INFO] Reactor Build Order:
[INFO] 
[INFO] piggymetrics                                                       [pom]
[INFO] config                                                             [jar]
[INFO] monitoring                                                         [jar]
[INFO] registry                                                           [jar]
[INFO] gateway                                                            [jar]
[INFO] auth-service                                                       [jar]
[INFO] account-service                                                    [jar]
[INFO] statistics-service                                                 [jar]
[INFO] notification-service                                               [jar]
[INFO] turbine-stream-service                                             [jar]
[INFO] 
[INFO] -------------------< com.piggymetrics:piggymetrics >--------------------
[INFO] Building piggymetrics 1.0-SNAPSHOT                                [1/10]
[INFO] --------------------------------[ pom ]---------------------------------
[INFO] 
[INFO] ----------------------< com.piggymetrics:config >-----------------------
[INFO] Building config 1.0.0-SNAPSHOT                                    [2/10]
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] --- maven-resources-plugin:3.0.1:resources (default-resources) @ config ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 2 resources
[INFO] Copying 8 resources
[INFO] 
[INFO] --- maven-compiler-plugin:3.7.0:compile (default-compile) @ config ---
[INFO] Nothing to compile - all classes are up to date
[INFO] 
[INFO] --------------------< com.piggymetrics:monitoring >---------------------
[INFO] Building monitoring 0.0.1-SNAPSHOT                                [3/10]
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] --- maven-resources-plugin:3.0.1:resources (default-resources) @ monitoring ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 0 resource
[INFO] Copying 1 resource
[INFO] 
[INFO] --- maven-compiler-plugin:3.7.0:compile (default-compile) @ monitoring ---
[INFO] Nothing to compile - all classes are up to date
[INFO] 
[INFO] ---------------------< com.piggymetrics:registry >----------------------
[INFO] Building registry 0.0.1-SNAPSHOT                                  [4/10]
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] --- maven-resources-plugin:3.0.1:resources (default-resources) @ registry ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 0 resource
[INFO] Copying 1 resource
[INFO] 
[INFO] --- maven-compiler-plugin:3.7.0:compile (default-compile) @ registry ---
[INFO] Nothing to compile - all classes are up to date
[INFO] 
[INFO] ----------------------< com.piggymetrics:gateway >----------------------
[INFO] Building gateway 1.0-SNAPSHOT                                     [5/10]
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] --- maven-resources-plugin:3.0.1:resources (default-resources) @ gateway ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 0 resource
[INFO] Copying 49 resources
[INFO] 
[INFO] --- maven-compiler-plugin:3.7.0:compile (default-compile) @ gateway ---
[INFO] Nothing to compile - all classes are up to date
[INFO] 
[INFO] -------------------< com.piggymetrics:auth-service >--------------------
[INFO] Building auth-service 1.0-SNAPSHOT                                [6/10]
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] --- jacoco-maven-plugin:0.7.6.201602180812:prepare-agent (default) @ auth-service ---
[INFO] argLine set to -javaagent:/home/jenkins/.m2/repository/org/jacoco/org.jacoco.agent/0.7.6.201602180812/org.jacoco.agent-0.7.6.201602180812-runtime.jar=destfile=/var/lib/jenkins/workspace/Piggy/auth-service/target/jacoco.exec
[INFO] 
[INFO] --- maven-resources-plugin:3.0.1:resources (default-resources) @ auth-service ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 0 resource
[INFO] Copying 1 resource
[INFO] 
[INFO] --- maven-compiler-plugin:3.7.0:compile (default-compile) @ auth-service ---
[INFO] Nothing to compile - all classes are up to date
[INFO] 
[INFO] ------------------< com.piggymetrics:account-service >------------------
[INFO] Building account-service 1.0-SNAPSHOT                             [7/10]
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] --- jacoco-maven-plugin:0.7.6.201602180812:prepare-agent (default) @ account-service ---
[INFO] argLine set to -javaagent:/home/jenkins/.m2/repository/org/jacoco/org.jacoco.agent/0.7.6.201602180812/org.jacoco.agent-0.7.6.201602180812-runtime.jar=destfile=/var/lib/jenkins/workspace/Piggy/account-service/target/jacoco.exec
[INFO] 
[INFO] --- maven-resources-plugin:3.0.1:resources (default-resources) @ account-service ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 0 resource
[INFO] Copying 1 resource
[INFO] 
[INFO] --- maven-compiler-plugin:3.7.0:compile (default-compile) @ account-service ---
[INFO] Nothing to compile - all classes are up to date
[INFO] 
[INFO] ----------------< com.piggymetrics:statistics-service >-----------------
[INFO] Building statistics-service 1.0-SNAPSHOT                          [8/10]
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] --- jacoco-maven-plugin:0.7.6.201602180812:prepare-agent (default) @ statistics-service ---
[INFO] argLine set to -javaagent:/home/jenkins/.m2/repository/org/jacoco/org.jacoco.agent/0.7.6.201602180812/org.jacoco.agent-0.7.6.201602180812-runtime.jar=destfile=/var/lib/jenkins/workspace/Piggy/statistics-service/target/jacoco.exec
[INFO] 
[INFO] --- maven-resources-plugin:3.0.1:resources (default-resources) @ statistics-service ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 0 resource
[INFO] Copying 1 resource
[INFO] 
[INFO] --- maven-compiler-plugin:3.7.0:compile (default-compile) @ statistics-service ---
[INFO] Nothing to compile - all classes are up to date
[INFO] 
[INFO] ---------------< com.piggymetrics:notification-service >----------------
[INFO] Building notification-service 1.0.0-SNAPSHOT                      [9/10]
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] --- jacoco-maven-plugin:0.7.6.201602180812:prepare-agent (default) @ notification-service ---
[INFO] argLine set to -javaagent:/home/jenkins/.m2/repository/org/jacoco/org.jacoco.agent/0.7.6.201602180812/org.jacoco.agent-0.7.6.201602180812-runtime.jar=destfile=/var/lib/jenkins/workspace/Piggy/notification-service/target/jacoco.exec
[INFO] 
[INFO] --- maven-resources-plugin:3.0.1:resources (default-resources) @ notification-service ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 0 resource
[INFO] Copying 1 resource
[INFO] 
[INFO] --- maven-compiler-plugin:3.7.0:compile (default-compile) @ notification-service ---
[INFO] Nothing to compile - all classes are up to date
[INFO] 
[INFO] --------------< com.piggymetrics:turbine-stream-service >---------------
[INFO] Building turbine-stream-service 0.0.1-SNAPSHOT                   [10/10]
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] --- maven-resources-plugin:3.0.1:resources (default-resources) @ turbine-stream-service ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 0 resource
[INFO] Copying 1 resource
[INFO] 
[INFO] --- maven-compiler-plugin:3.7.0:compile (default-compile) @ turbine-stream-service ---
[INFO] Nothing to compile - all classes are up to date
[INFO] ------------------------------------------------------------------------
[INFO] Reactor Summary:
[INFO] 
[INFO] piggymetrics 1.0-SNAPSHOT .......................... SUCCESS [  0.019 s]
[INFO] config 1.0.0-SNAPSHOT .............................. SUCCESS [  4.413 s]
[INFO] monitoring 0.0.1-SNAPSHOT .......................... SUCCESS [  1.263 s]
[INFO] registry 0.0.1-SNAPSHOT ............................ SUCCESS [  1.046 s]
[INFO] gateway ............................................ SUCCESS [  0.674 s]
[INFO] auth-service ....................................... SUCCESS [  3.375 s]
[INFO] account-service .................................... SUCCESS [  1.460 s]
[INFO] statistics-service ................................. SUCCESS [  0.708 s]
[INFO] notification-service 1.0.0-SNAPSHOT ................ SUCCESS [  0.800 s]
[INFO] turbine-stream-service 0.0.1-SNAPSHOT .............. SUCCESS [  1.013 s]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 18.746 s
[INFO] Finished at: 2019-05-07T13:14:48Z
[INFO] ------------------------------------------------------------------------
[Piggy] $ /bin/sh -xe /tmp/jenkins7913684931265432531.sh
+ docker stack deploy -c /vagrant/docker-compose.yml piggymetricks
Ignoring unsupported options: restart

Updating service piggymetricks_rabbitmq (id: rz2w18ofylae3p7ofhill8ave)
Updating service piggymetricks_auth-service (id: v6r0ideat7d43esv9g98xoben)
Updating service piggymetricks_statistics-mongodb (id: inetm5rm66nau7tx05ee18hro)
Updating service piggymetricks_account-service (id: osqqlsay1d2xjwar8wrz5eo2o)
Updating service piggymetricks_account-mongodb (id: zb51453j4oepxdbjysxns89zy)
Updating service piggymetricks_auth-mongodb (id: 170mgoibhchfkswqny6wxdes7)
Updating service piggymetricks_statistics-service (id: agsgqp7zwdgd0i7kbdmn7kjkx)
Updating service piggymetricks_gateway (id: ss0cybshqrhtyr96p6xfnkv51)
Updating service piggymetricks_notification-mongodb (id: u51xkhgwot9r98q4mg6kdfjb7)
Updating service piggymetricks_monitoring (id: odz7sgiyb8tb43qf6jhao5vgi)
Updating service piggymetricks_registry (id: jww7te0fi2kbf494o02r6do8l)
Updating service piggymetricks_notification-service (id: ulboy8awkz2kmzrt31an4sll1)
Updating service piggymetricks_config (id: zwt9o7wmmjjagmwjqqo05xhut)
+ docker service ls
ID                  NAME                                 MODE                REPLICAS            IMAGE                                            PORTS
zb51453j4oep        piggymetricks_account-mongodb        replicated          1/1                 sqshq/piggymetrics-mongodb:latest                
osqqlsay1d2x        piggymetricks_account-service        replicated          1/1                 sqshq/piggymetrics-account-service:latest        
170mgoibhchf        piggymetricks_auth-mongodb           replicated          0/1                 sqshq/piggymetrics-mongodb:latest                
v6r0ideat7d4        piggymetricks_auth-service           replicated          1/1                 sqshq/piggymetrics-auth-service:latest           
zwt9o7wmmjja        piggymetricks_config                 replicated          1/1                 sqshq/piggymetrics-config:latest                 
ss0cybshqrht        piggymetricks_gateway                replicated          0/1                 sqshq/piggymetrics-gateway:latest                *:80->4000/tcp
odz7sgiyb8tb        piggymetricks_monitoring             replicated          0/1                 sqshq/piggymetrics-monitoring:latest             *:8989->8989/tcp, *:9000->8080/tcp
u51xkhgwot9r        piggymetricks_notification-mongodb   replicated          0/1                 sqshq/piggymetrics-mongodb:latest                
ulboy8awkz2k        piggymetricks_notification-service   replicated          1/1                 sqshq/piggymetrics-notification-service:latest   
rz2w18ofylae        piggymetricks_rabbitmq               replicated          1/1                 rabbitmq:3-management                            *:15672->15672/tcp
jww7te0fi2kb        piggymetricks_registry               replicated          0/1                 sqshq/piggymetrics-registry:latest               *:8761->8761/tcp
inetm5rm66na        piggymetricks_statistics-mongodb     replicated          0/1                 sqshq/piggymetrics-mongodb:latest                
agsgqp7zwdgd        piggymetricks_statistics-service     replicated          1/1                 sqshq/piggymetrics-statistics-service:latest     
rqwhxql8meco        ucp-agent                            global              2/2                 docker/ucp-agent:2.2.4                           
endvluu9aqpq        ucp-agent-s390x                      global              0/0                 docker/ucp-agent-s390x:2.2.4                     
mokbyilc0p0p        ucp-agent-win                        global              0/0                 docker/ucp-agent-win:2.2.4                       
Finished: SUCCESS
```

