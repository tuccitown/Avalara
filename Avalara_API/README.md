Prerequisites

    Node JS
    NPM
    Docker

Build Steps

    1.  Unzip Avalara-API.zip
    2.  Change directories into Avalara-API
    3.  Run "bash build.sh" Build script will setup test environment and validate the containters are working as expected.
    4.  Run curl to validate end to end tests.
        curl --header "Content-Type: application/json" --request POST --data '{"id": "i-0085a516efcc628d6","description": "This server is unhealthy"}' http://localhost:8081/actions

