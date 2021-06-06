
# Delete existing artifacts
rm genesis.block mychannel.tx
rm -rf ../../channel-artifacts/*

#Generate Crypto artifactes for organizations
# cryptogen generate --config=./crypto-config.yaml --output=./crypto-config/



# System channel
SYS_CHANNEL="sys-channel"

# channel name defaults to "mychannel"
CHANNEL_NAME="mychannel"

echo $CHANNEL_NAME

# Generate System Genesis block
configtxgen -profile OrdererGenesis -configPath . -channelID $SYS_CHANNEL  -outputBlock ./genesis.block


# Generate channel configuration block
configtxgen -profile BasicChannel -configPath . -outputCreateChannelTx ./mychannel.tx -channelID $CHANNEL_NAME

echo "#######    Generating anchor peer update for BankMSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./BankMSPanchors.tx -channelID $CHANNEL_NAME -asOrg BankMSP

echo "#######    Generating anchor peer update for OrganizationMSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./OrganizationMSPanchors.tx -channelID $CHANNEL_NAME -asOrg OrganizationMSP

echo "#######    Generating anchor peer update for UserMSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./UserMSPanchors.tx -channelID $CHANNEL_NAME -asOrg UserMSP