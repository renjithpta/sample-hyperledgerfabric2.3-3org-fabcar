createcertificatesForBank() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/peerOrganizations/bank.example.com/
  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/bank.example.com/

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca.bank.example.com --tls.certfiles ${PWD}/fabric-ca/bank/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-bank-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-bank-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-bank-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-bank-example-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/bank.example.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo
  fabric-ca-client register --caname ca.bank.example.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/bank/tls-cert.pem

  echo
  echo "Register user"
  echo
  fabric-ca-client register --caname ca.bank.example.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/bank/tls-cert.pem

  echo
  echo "Register the org admin"
  echo
  fabric-ca-client register --caname ca.bank.example.com --id.name bankadmin --id.secret bankadminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/bank/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/bank.example.com/peers

  # -----------------------------------------------------------------------------------
  #  Peer 0
  mkdir -p ../crypto-config/peerOrganizations/bank.example.com/peers/peer0.bank.example.com

  echo
  echo "## Generate the peer0 msp"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.bank.example.com -M ${PWD}/../crypto-config/peerOrganizations/bank.example.com/peers/peer0.bank.example.com/msp --csr.hosts peer0.bank.example.com --tls.certfiles ${PWD}/fabric-ca/bank/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/bank.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/bank.example.com/peers/peer0.bank.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.bank.example.com -M ${PWD}/../crypto-config/peerOrganizations/bank.example.com/peers/peer0.bank.example.com/tls --enrollment.profile tls --csr.hosts peer0.bank.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/bank/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/bank.example.com/peers/peer0.bank.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/bank.example.com/peers/peer0.bank.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/bank.example.com/peers/peer0.bank.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/bank.example.com/peers/peer0.bank.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/bank.example.com/peers/peer0.bank.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/bank.example.com/peers/peer0.bank.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/bank.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/bank.example.com/peers/peer0.bank.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/bank.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/bank.example.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/bank.example.com/peers/peer0.bank.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/bank.example.com/tlsca/tlsca.bank.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/bank.example.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/bank.example.com/peers/peer0.bank.example.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/bank.example.com/ca/ca.bank.example.com-cert.pem

  # --------------------------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/bank.example.com/users
  mkdir -p ../crypto-config/peerOrganizations/bank.example.com/users/User1@bank.example.com

  echo
  echo "## Generate the user msp"
  echo
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca.bank.example.com -M ${PWD}/../crypto-config/peerOrganizations/bank.example.com/users/User1@bank.example.com/msp --tls.certfiles ${PWD}/fabric-ca/bank/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/bank.example.com/users/Admin@bank.example.com

  echo
  echo "## Generate the org admin msp"
  echo
  fabric-ca-client enroll -u https://bankadmin:bankadminpw@localhost:7054 --caname ca.bank.example.com -M ${PWD}/../crypto-config/peerOrganizations/bank.example.com/users/Admin@bank.example.com/msp --tls.certfiles ${PWD}/fabric-ca/bank/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/bank.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/bank.example.com/users/Admin@bank.example.com/msp/config.yaml

}

# createcertificatesForBank

createCertificatesForOrganization() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p /../crypto-config/peerOrganizations/organization.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/organization.example.com/

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca.organization.example.com --tls.certfiles ${PWD}/fabric-ca/organization/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-organization-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-organization-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-organization-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-organization-example-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/organization.example.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo
   
  fabric-ca-client register --caname ca.organization.example.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/organization/tls-cert.pem
   

  echo
  echo "Register user"
  echo
   
  fabric-ca-client register --caname ca.organization.example.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/organization/tls-cert.pem
   

  echo
  echo "Register the org admin"
  echo
   
  fabric-ca-client register --caname ca.organization.example.com --id.name organizationadmin --id.secret organizationadminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/organization/tls-cert.pem
   

  mkdir -p ../crypto-config/peerOrganizations/organization.example.com/peers
  mkdir -p ../crypto-config/peerOrganizations/organization.example.com/peers/peer0.organization.example.com

  # --------------------------------------------------------------
  # Peer 0
  echo
  echo "## Generate the peer0 msp"
  echo
   
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca.organization.example.com -M ${PWD}/../crypto-config/peerOrganizations/organization.example.com/peers/peer0.organization.example.com/msp --csr.hosts peer0.organization.example.com --tls.certfiles ${PWD}/fabric-ca/organization/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/organization.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/organization.example.com/peers/peer0.organization.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca.organization.example.com -M ${PWD}/../crypto-config/peerOrganizations/organization.example.com/peers/peer0.organization.example.com/tls --enrollment.profile tls --csr.hosts peer0.organization.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/organization/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/organization.example.com/peers/peer0.organization.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/organization.example.com/peers/peer0.organization.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/organization.example.com/peers/peer0.organization.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/organization.example.com/peers/peer0.organization.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/organization.example.com/peers/peer0.organization.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/organization.example.com/peers/peer0.organization.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/organization.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/organization.example.com/peers/peer0.organization.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/organization.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/organization.example.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/organization.example.com/peers/peer0.organization.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/organization.example.com/tlsca/tlsca.organization.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/organization.example.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/organization.example.com/peers/peer0.organization.example.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/organization.example.com/ca/ca.organization.example.com-cert.pem

  # --------------------------------------------------------------------------------
 
  mkdir -p ../crypto-config/peerOrganizations/organization.example.com/users
  mkdir -p ../crypto-config/peerOrganizations/organization.example.com/users/User1@organization.example.com

  echo
  echo "## Generate the user msp"
  echo
   
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca.organization.example.com -M ${PWD}/../crypto-config/peerOrganizations/organization.example.com/users/User1@organization.example.com/msp --tls.certfiles ${PWD}/fabric-ca/organization/tls-cert.pem
   

  mkdir -p ../crypto-config/peerOrganizations/organization.example.com/users/Admin@organization.example.com

  echo
  echo "## Generate the org admin msp"
  echo
   
  fabric-ca-client enroll -u https://organizationadmin:organizationadminpw@localhost:8054 --caname ca.organization.example.com -M ${PWD}/../crypto-config/peerOrganizations/organization.example.com/users/Admin@organization.example.com/msp --tls.certfiles ${PWD}/fabric-ca/organization/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/organization.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/organization.example.com/users/Admin@organization.example.com/msp/config.yaml

}

# createCertificateForOrganization

createCertificatesForUser() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p /../crypto-config/peerOrganizations/user.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/user.example.com/

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:10054 --caname ca.user.example.com --tls.certfiles ${PWD}/fabric-ca/user/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-user-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-user-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-user-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-user-example-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/user.example.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo
   
  fabric-ca-client register --caname ca.user.example.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/user/tls-cert.pem
   

  echo
  echo "Register user"
  echo
   
  fabric-ca-client register --caname ca.user.example.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/user/tls-cert.pem
   

  echo
  echo "Register the org admin"
  echo
   
  fabric-ca-client register --caname ca.user.example.com --id.name useradmin --id.secret useradminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/user/tls-cert.pem
   

  mkdir -p ../crypto-config/peerOrganizations/user.example.com/peers
  mkdir -p ../crypto-config/peerOrganizations/user.example.com/peers/peer0.user.example.com

  # --------------------------------------------------------------
  # Peer 0
  echo
  echo "## Generate the peer0 msp"
  echo
   
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca.user.example.com -M ${PWD}/../crypto-config/peerOrganizations/user.example.com/peers/peer0.user.example.com/msp --csr.hosts peer0.user.example.com --tls.certfiles ${PWD}/fabric-ca/user/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/user.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/user.example.com/peers/peer0.user.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca.user.example.com -M ${PWD}/../crypto-config/peerOrganizations/user.example.com/peers/peer0.user.example.com/tls --enrollment.profile tls --csr.hosts peer0.user.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/user/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/user.example.com/peers/peer0.user.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/user.example.com/peers/peer0.user.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/user.example.com/peers/peer0.user.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/user.example.com/peers/peer0.user.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/user.example.com/peers/peer0.user.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/user.example.com/peers/peer0.user.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/user.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/user.example.com/peers/peer0.user.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/user.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/user.example.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/user.example.com/peers/peer0.user.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/user.example.com/tlsca/tlsca.user.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/user.example.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/user.example.com/peers/peer0.user.example.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/user.example.com/ca/ca.user.example.com-cert.pem

  # --------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/user.example.com/users
  mkdir -p ../crypto-config/peerOrganizations/user.example.com/users/User1@user.example.com

  echo
  echo "## Generate the user msp"
  echo
   
  fabric-ca-client enroll -u https://user1:user1pw@localhost:10054 --caname ca.user.example.com -M ${PWD}/../crypto-config/peerOrganizations/user.example.com/users/User1@user.example.com/msp --tls.certfiles ${PWD}/fabric-ca/user/tls-cert.pem
   

  mkdir -p ../crypto-config/peerOrganizations/user.example.com/users/Admin@user.example.com

  echo
  echo "## Generate the org admin msp"
  echo
   
  fabric-ca-client enroll -u https://useradmin:useradminpw@localhost:10054 --caname ca.user.example.com -M ${PWD}/../crypto-config/peerOrganizations/user.example.com/users/Admin@user.example.com/msp --tls.certfiles ${PWD}/fabric-ca/user/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/user.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/user.example.com/users/Admin@user.example.com/msp/config.yaml

}

createCretificatesForOrderer() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/ordererOrganizations/example.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/ordererOrganizations/example.com

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/ordererOrganizations/example.com/msp/config.yaml

  echo
  echo "Register orderer"
  echo
   
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  echo
  echo "Register orderer2"
  echo
   
  fabric-ca-client register --caname ca-orderer --id.name orderer2 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  echo
  echo "Register orderer3"
  echo
   
  fabric-ca-client register --caname ca-orderer --id.name orderer3 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  echo
  echo "Register the orderer admin"
  echo
   
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  mkdir -p ../crypto-config/ordererOrganizations/example.com/orderers
  # mkdir -p ../crypto-config/ordererOrganizations/example.com/orderers/example.com

  # ---------------------------------------------------------------------------
  #  Orderer

  mkdir -p ../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com

  echo
  echo "## Generate the orderer msp"
  echo
   
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls --enrollment.profile tls --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/ordererOrganizations/example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  # -----------------------------------------------------------------------
  #  Orderer 2

  mkdir -p ../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com

  echo
  echo "## Generate the orderer msp"
  echo
   
  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/msp --csr.hosts orderer2.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tls --enrollment.profile tls --csr.hosts orderer2.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  # mkdir ${PWD}/../crypto-config/ordererOrganizations/example.com/msp/tlscacerts
  # cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  # ---------------------------------------------------------------------------
  #  Orderer 3
  mkdir -p ../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com

  echo
  echo "## Generate the orderer msp"
  echo
   
  fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/msp --csr.hosts orderer3.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tls --enrollment.profile tls --csr.hosts orderer3.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  # mkdir ${PWD}/../crypto-config/ordererOrganizations/example.com/msp/tlscacerts
  # cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  # ---------------------------------------------------------------------------

  mkdir -p ../crypto-config/ordererOrganizations/example.com/users
  mkdir -p ../crypto-config/ordererOrganizations/example.com/users/Admin@example.com

  echo
  echo "## Generate the admin msp"
  echo
   
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml

}

# createCretificateForOrderer

sudo rm -rf ../crypto-config/*
# sudo rm -rf fabric-ca/*
createcertificatesForBank
createCertificatesForOrganization
createCertificatesForUser

createCretificatesForOrderer

