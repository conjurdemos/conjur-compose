# conjur-compose
Bring up a Conjur HA cluster using docker-compose. Check out a terminal recording here: https://asciinema.org/a/3h85talp2ku29eleffmeszw9s

## Install
First, obtain the Conjur appliance tarball from Conjur.

Load the image, then tag it
```
docker load -i conjur.tgz
docker tag conjurinc/appliance:45 conjur-appliance
```
## Run
To run
```
CONJUR_MASTER_PASSWORD=your_secure_password docker-compose up --no-recreate
```
Make sure to use `--no-recreate` unless you want to re-initialize the appliance. 

To connect the Conjur CLI to the cluster
```
docker build -t conjur_cli cli
docker run -it --rm \
  --link conjurcluster_master_1:conjur-master \
  --link conjurcluster_follower_1:conjur-follower \
  -v $PWD/cli/policy.rb:/root/policy.rb \
  conjur_cli /bin/bash
```   
Then, within the container
```
# conjur init -h conjur-master
# conjur bootstrap
```

To stop
```
docker-compose stop
```

## How it works
* specialized images for master, standy, follower that extend base image
* standby, follower depend on master -- when they come up, they wait for the master to generate the seed files
* seed files credential standby, follower, giving them access to the encrypted info in the database, and the ability to connect to each other
* This example brings everything up on the same host. To deploy in a distributed environment, the seed file should be encrypted. Then, the seed file can be deployed to the remote server, along with the decryption key. Once on the remote server, it can decrypt the seed file and start the server.
