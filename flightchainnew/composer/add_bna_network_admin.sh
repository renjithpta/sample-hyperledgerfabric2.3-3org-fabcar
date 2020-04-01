#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
WORKING_DIR="certificates";
KEY1="INSERT_ORDERER_CA_CERT";
KEY2="INSERT_ORG1_CA_CERT"
CRYPTO_DIR=$DIR/../crypto-config
ORG1=$CRYPTO_DIR/peerOrganizations/britishairways.ibs.aero/users/Admin@britishairways.ibs.aero/msp

BNA_FILE="$1"
: ${BNA_FILE:="tutorial-network"}

composer network install -a $BNA_FILE@0.0.2.bna -c PeerAdmin@bymn-britishairways
composer network upgrade -c PeerAdmin@bymn-britishairways -n tutorial-network -V 0.0.2
