#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        ./ccp-template.json
}

ORG=1
P0PORT=7051
CAPORT=7054
PEERPEM=../../artifacts/channel/crypto-config/peerOrganizations/bank.example.com/peers/peer0.bank.example.com/tls/tlscacerts/tls-localhost-7054-ca-bank-example-com.pem
CAPEM=../../artifacts/channel/crypto-config/peerOrganizations/bank.example.com/msp/tlscacerts/ca.crt

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM )" > connection-bank.json

ORG=2
P0PORT=9051
CAPORT=8054
PEERPEM=../../artifacts/channel/crypto-config/peerOrganizations/organization.example.com/peers/peer0.organization.example.com/tls/tlscacerts/tls-localhost-8054-ca-organization-example-com.pem
CAPEM=../../artifacts/channel/crypto-config/peerOrganizations/organization.example.com/msp/tlscacerts/ca.crt

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > connection-organization.json

ORG=3
P0PORT=11051
CAPORT=10054
PEERPEM=../../artifacts/channel/crypto-config/peerOrganizations/user.example.com/peers/peer0.user.example.com/tls/tlscacerts/tls-localhost-10054-ca-user-example-com.pem
CAPEM=../../artifacts/channel/crypto-config/peerOrganizations/user.example.com/msp/tlscacerts/ca.crt


echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > connection-user.json