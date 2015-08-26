#!/bin/bash -e

echo "Waiting for seed file $SEED_DIR/follower-${CONJUR_FOLLOWER_HOSTNAME}...."
while [ ! -e "$SEED_DIR/follower-${CONJUR_FOLLOWER_HOSTNAME}-seed.ready" ]; do
    sleep 1
done

set -x
evoke configure follower $SEED_DIR/follower-${CONJUR_FOLLOWER_HOSTNAME}-seed

/sbin/my_init
