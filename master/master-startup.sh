#!/bin/bash -ex

evoke configure master -h $CONJUR_MASTER_HOSTNAME -p $CONJUR_MASTER_PASSWORD $CONJUR_MASTER_ORGACCOUNT

if [ ! -z "$CONJUR_STANDBY_HOSTNAME" ]; then
  evoke seed standby $CONJUR_MASTER_HOSTNAME $CONJUR_STANDBY_HOSTNAME > $SEED_DIR/standby-seed && touch $SEED_DIR/standby-seed.ready
fi

for f in $CONJUR_FOLLOWER_HOSTNAMES; do
  evoke seed follower $CONJUR_MASTER_HOSTNAME $f > $SEED_DIR/follower-${f}-seed && touch $SEED_DIR/follower-${f}-seed.ready
done

/sbin/my_init

  
