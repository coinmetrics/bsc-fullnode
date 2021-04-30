#!/bin/sh

geth --nousb --datadir /opt/data init /usr/share/genesis.json
geth "$@"
