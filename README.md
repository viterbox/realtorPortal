# realtorPortal
A simple real estate portal


## Technologies

Rails version: 5.1.2

Ruby version: 2.4.1 

Mongo 3.*

## Instructions

1. Run rails server

2. Execute script that synchronizes the properties:
    
    curl http://localhost:3000/updater/index?type=TROVIT -v

3. Visit realtorPortal, opening in browser:

    http://localhost:3000/items/list

