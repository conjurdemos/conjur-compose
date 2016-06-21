# conjur-compose
Bring up a [Conjur HA cluster](https://developer.conjur.net/reference/architecture/ha.html) using docker-compose. Check out a terminal recording here: https://asciinema.org/a/3h85talp2ku29eleffmeszw9s

## Install
First, [contact Conjur](http://www.conjur.net/about/contact) to obtain the Conjur appliance tarball.

Download the tarball, load the image, then tag it
```
docker load -i conjur.tgz
docker tag conjurinc/appliance:45 conjur-appliance:latest
```
## Run
To run
```
CONJUR_MASTER_PASSWORD=your_secure_password docker-compose up --no-recreate
```
Make sure to use `--no-recreate` unless you want to delete all data and completely re-initialize the appliance. 

To connect the Conjur CLI to the cluster, start a shell with the appropriate Docker links
```
docker build -t conjur_cli cli
docker run -it \
  --link conjurcluster_master_1:conjur-master \
  --link conjurcluster_follower_1:conjur-follower \
  -v $PWD/cli/policy.rb:/root/policy.rb \
  conjur_cli /bin/bash
```   
In the shell, you can connect to the server and bootstrap it.
```
# conjur init -h conjur-master
# conjur bootstrap
```
(You only need to bootstrap the server once.)

To stop
```
docker-compose stop
```

## How it works
The first time `docker-compose up` is run, [docker-compose.yml](https://github.com/conjurdemos/conjur-compose/blob/master/docker-compose.yml) begins by creating images to use for master, standy, and follower servers. Each extend the base conjur-appliance image. The conjur-appliance image is based on [phusion:baseimage](https://hub.docker.com/r/phusion/baseimage/) which uses [runit](http://smarden.org/runit/) as its init system.

After the images are created, containers are started. The standby and follower containers are each linked to the master container. They also share a volume from the master where seed files will be stored. (A Conjur seed file credentials a server to connect to a particular master, and contains the database keys and certificates required to act as either a standby or a follower.)

Master, standby, and follower each have specialized [run scripts](http://smarden.org/runit/faq.html#create). The scripts first check to see if the server is already configured. If it is, then it does nothing. If it is not, what it does depends on the server type: 
* the master runs `evoke configure master` to configure itself. When it's done, it generates a seed file for each of the other server types
* the standby waits for its seed file to be ready, then configures itself with `evoke configure standby`
* the follower also waits for its seed file, the configures itself with `evoke configure follower`

This example brings everything up on the same host. To deploy in a distributed environment, where followers are separate from the master, some mechanism will be necessary to ensure that the sensitive information in the seed file is protected. Using a separate container, the seed file can be extracted from the master's seed volume, encrypted, and stored. (Consider storing the encryption key and seed file separately.) The seed file can then be copied to a volume shared with the follower and decrypted.
