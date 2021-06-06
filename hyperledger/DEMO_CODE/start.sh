docker-compose -f ${PWD}/artifacts/docker-compose.yaml down -v
docker-compose -f ${PWD}/artifacts/channel/create-certificate-with-ca/docker-compose.yaml down -v
docker-compose -f ${PWD}/artifacts/docker-compose.yaml up -d
sleep 5
docker-compose -f ${PWD}/artifacts/channel/create-certificate-with-ca/docker-compose.yaml up -d
sleep 10
./createChannel.sh
sleep 10
./deployChaincode.sh






