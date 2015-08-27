# conjur-compose
Bring up a Conjur HA cluster using docker-compose

## Build
First, obtain the conjur-appliance tarball from Conjur.

Import it
```
docker import conjur-appliance.tar conjur-appliance
```

Then
```
make images
```

## Run

To run
```
docker-compose up --no-recreate
```
Make sure to use `--no-recreate` unless you want to re-initialize the appliance. 

```
To stop
docker-compose stop
```

