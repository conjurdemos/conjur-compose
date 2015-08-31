# conjur-compose
Bring up a Conjur HA cluster using docker-compose. Check out a terminal recording here: _https://asciinema.org/a/3h85talp2ku29eleffmeszw9s_

## Install
First, obtain the conjur-appliance tarball from Conjur.

Load the image, then tag it
```
docker load -i conjur-appliance.tgz
docker tag conjurinc/appliance:45 conjur-appliance
```
## Run
To run
```
CONJUR_MASTER_PASSWORD=your_secure_password docker-compose up --no-recreate
```
Make sure to use `--no-recreate` unless you want to re-initialize the appliance. 

To stop
```
docker-compose stop
```

