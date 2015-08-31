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

