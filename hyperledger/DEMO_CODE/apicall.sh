#!/bin/bash
echo "Extract bearer token from curl calling login api"
echo
# Check cURL command if available (required), abort if does not exists
type curl >/dev/null 2>&1 || { echo >&2 "Required curl but it's not installed. Aborting."; exit 1; }
echo

curl --location --request POST 'http://localhost:4000/users' \
--header 'Content-Type: application/json' \
--data-raw '{
    "username": "bankuser",
    "orgName": "Bank"
}'

PAYLOAD='{"username": "bankuser2", "password": "Bank"}'

RESPONSE=`curl -s --request POST -H "Content-Type:application/json" http://localhost:4000/users --data "${PAYLOAD}"`

TOKEN=`echo $RESPONSE | grep -Po '"token":(\W+)?"\K[a-zA-Z0-9._]+(?=")'`

echo "TOEKN $TOKEN" # Use for further processsing
sleep 5

RESPONSE=`curl -s --request POST -H "Content-Type:application/json" http://localhost:4000/users/login --data "${PAYLOAD}"`
TOKEN=`echo $RESPONSE | grep -Po '"token":(\W+)?"\K[a-zA-Z0-9._]+(?=")'`
echo "Login$TOKEN" # Use for further processsing

