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

To stop
```
docker-compose stop
```

