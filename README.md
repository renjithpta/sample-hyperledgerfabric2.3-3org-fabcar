#DEMO

Network Topology

Three Orgs(Peer Orgs)

    - Each Org have one peer(Each Endorsing Peer)
    - Each Org have separate Certificate Authority
    - Each Peer has Current State database as couch db


One Orderer Org

    - Three Orderers
    - One Certificate Authority

Prerequiste

Hyperledger Fabric 2.3
Go 1.15
Node 1.10.x or later
Curl



Steps:

1) Clone the repo
2) Run sudo chmod -R +rwx *.sh in the cloned repo
3) go to apiserver folder and run npm i
3) Run ./access
4) Create Channel Artifacts using Org MSP
5) Create Channel and join peers
6) Deploy Chaincode
   1) Install All dependency
   2) Package Chaincode
   3) Install Chaincode on all Endorsing Peer
   4) Approve Chaincode as per Lifecycle Endorsment Policy
   5) Commit Chaincode Defination
7) Create Connection Profiles
8) Start API Server
9) Register User using API
10) Invoke Chaincode Transaction
11) Query Chaincode Transaction
