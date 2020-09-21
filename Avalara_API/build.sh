#!/bin/bash
YL='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color
GR='\033[0;34m'
printf "${YL}Building containers...\n${NC}"
docker build --pull --rm -f "Dockerfile" -t avalaraapi:latest "." 
docker build --pull --rm -f "Dockerfile" -t avalarasingnalfx:latest "../Avalara_SingnalFX/" 
printf "${YL}Completed...\n${NC}"
printf "${YL}Running Containers....\n${NC}"
API=$(docker run --rm -d --name avalara-api -p 8081:8081/tcp avalaraapi:latest)
DUMMYFX=$(docker run --rm -d --name avalara-sfk -p 8082:8082/tcp avalarasingnalfx:latest)
printf "${YL}Completed...\n${NC}"
printf "${YL}Creating container network...\n${NC}"
docker network create avalara
printf "${YL}Completed...${NC}"
printf "${YL}Adding containers to network...\n${NC}"
docker network connect avalara avalara-api
docker network connect avalara avalara-sfk
printf "${YL}Setup Complete\n${NC}"

printf "${GR}Run to start shell on API:  docker exec -it $API bash\n${NC}"
printf "${GR}Run to start shell on SIGNAL Fx:  docker exec -it $DUMMYFX bash\n${NC}"
printf "${GR}Run to start tailing logs on API:  docker logs -f $API\n"
printf "${GR}Run to start tailing logson SIGNAL Fx:  docker logs -f $DUMMYFX\n${NC}"

printf "${YL}Testing services...\n${NC}"


TESTAPI=$(curl --header "Content-Type: application/json" --request POST --data '{"id": "i-0085a516efcc628d6","description": "This server is unhealthy"}' http://localhost:8081/actions)
TESTDUMMY=$(curl --header "Content-Type: application/json" --request POST --data '{"category": "ALERT","dimensions": {"id": "i-0085a516efcc628d6","description": "This server is unhealthy"},"eventType": "instance_state_change","timestamp": 1600651865454}' http://localhost:8082/event)

if [[ $TESTAPI == *"timestamp"* ]]; then
    printf "${YL}API Service is responding as expected...\n${NC}"
else
    printf "${RED}API service failed to responde as expected\n${NC}"
fi
if [[ $TESTDUMMY == *"OK"* ]]; then
    printf "${YL}API Service is responding as expected...\n${NC}"
else
    printf "${RED}Dummy SX service is not responding as expected.\n${NC}"
fi

printf "${YL}Services Testing Completed\n${NC}"

printf "${YL}Testing End to End...\n${NC}"

TESTAPI=$(curl --header "Content-Type: application/json" --request POST --data '{"id": "i-0085a516efcc628d6","description": "This server is unhealthy"}' http://localhost:8081/actions)

printf "${YL}$TESTAPI\n${NC}"

logs=$(docker logs $DUMMYFX)

if [[ $logs == *"Got body:"* ]]; then
    printf "${YL}End to End test Successful.\n${NC}"
else 
    printf "${RED}End to End test FAILED.\n${NC}"
fi
