#!/bin/bash

echo
echo " ____    _____      _      ____    _____ "
echo "/ ___|  |_   _|    / \    |  _ \  |_   _|"
echo "\___ \    | |     / _ \   | |_) |   | |  "
echo " ___) |   | |    / ___ \  |  _ <    | |  "
echo "|____/    |_|   /_/   \_\ |_| \_\   |_|  "
echo
echo "Build your Multi network (BYMN) end-to-end test"
echo
CHANNEL_NAME="$1"
DELAY="$2"
LANGUAGE="$3"
TIMEOUT="$4"
VERBOSE="$5"
NO_CHAINCODE="$6"
: ${CHANNEL_NAME:="flightchannel"}
: ${DELAY:="3"}
: ${LANGUAGE:="golang"}
: ${TIMEOUT:="10"}
: ${VERBOSE:="false"}
: ${NO_CHAINCODE:="false"}
LANGUAGE=`echo "$LANGUAGE" | tr [:upper:] [:lower:]`
COUNTER=1
MAX_RETRY=10

CC_SRC_PATH="github.com/chaincode/chaincode_example02/go/"
if [ "$LANGUAGE" = "node" ]; then
	CC_SRC_PATH="/opt/gopath/src/github.com/chaincode/chaincode_example02/node/"
fi

if [ "$LANGUAGE" = "java" ]; then
	CC_SRC_PATH="/opt/gopath/src/github.com/chaincode/chaincode_example02/java/"
fi

echo "Channel name : "$CHANNEL_NAME

# import utils
. scripts/utils.sh

createChannel() {
	setGlobals 0 1

	if [ -z "$CORE_PEER_TLS_ENABLED" -o "$CORE_PEER_TLS_ENABLED" = "false" ]; then
                set -x
		peer channel create -o orderer0.ibs.aero:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx >&log.txt
		res=$?
                set +x
	else
				set -x
		peer channel create -o orderer0.ibs.aero:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA >&log.txt
		res=$?
				set +x
	fi
	cat log.txt
	verifyResult $res "Channel creation failed"
	echo "===================== Channel '$CHANNEL_NAME' created ===================== "
	echo
}

joinChannel () {
	for org in 1 2; do
	    for peer in 0 1; do
		 ORG_NAME="britishairways"
     if [ $ORG -eq 2 ]; then
     ORG_NAME="gatewick"
      fi
		joinChannelWithRetry $peer $org
		echo "===================== peer${peer}.${ORG_NAME} joined channel '$CHANNEL_NAME' ===================== "
		sleep $DELAY
		echo
	    done
	done
}

## Create channel
echo "Creating channel..."
createChannel

## Join all the peers to the channel
echo "Having all peers join the channel..."
joinChannel

## Set the anchor peers for each org in the channel
echo "Updating anchor peers for britishairways..."
updateAnchorPeers 0 1
echo "Updating anchor peers for gatewick..."
updateAnchorPeers 0 2

if [ "${NO_CHAINCODE}" != "true" ]; then

	## Install chaincode on peer0.britishairways and peer0.gatewick
	echo "Installing chaincode on peer0.britishairways..."
	installChaincode 0 1
	echo "Install chaincode on peer0.gatewick..."
	installChaincode 0 2

        # Instantiate chaincode on peer0.gatewick
	echo "Instantiating chaincode on peer0.britishairways..."
	instantiateChaincode 0 1

	# Instantiate chaincode on peer0.gatewick
	echo "Instantiating chaincode on peer0.gatewick..."
	instantiateChaincode 0 2

	# Query chaincode on peer0.britishairways
	echo "Querying chaincode on peer0.britishairways..."
	chaincodeQuery 0 1 100

	# Invoke chaincode on peer0.britishairways and peer0.gatewick
	echo "Sending invoke transaction on peer0.britishairways peer0.gatewick..."
	chaincodeInvoke 0 1 0 2
	
	## Install chaincode on peer1.gatewick
	echo "Installing chaincode on peer1.gatewick..."
	installChaincode 1 2

	# Query on chaincode on peer1.gatewick, check if the result is 90
	echo "Querying chaincode on peer1.gatewick..."
	chaincodeQuery 1 2 90
	
fi

echo
echo "========= All GOOD, BYMN execution completed =========== "
echo

echo
echo " _____   _   _   ____   "
echo "| ____| | \ | | |  _ \  "
echo "|  _|   |  \| | | | | | "
echo "| |___  | |\  | | |_| | "
echo "|_____| |_| \_| |____/  "
echo

exit 0
