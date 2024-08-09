# assignment-Wal

### Used Network library to get the state of network i.e. connected or not.

### Used coredata to support the cases where internet is not needed after visiting the APOD once in a day to limit the api hits.

### Case 1: When the apis is working and user haven't visited the APOD screen once in a day then calling the api, showing the result ot user and saving the data in the local DB as well.

### Case 2: When the user already visited APOD and internet is not there then fetching the data from local DB and showing to the screen.

### Case 3: When the user haven't visited the APOD screen and internet is also not there then showing an alert message and after "OK" button action checking the local DB for last entry and show or else show an error alert if DB is empty (To handle another edge case).

### Case 4: When api is working and internet is there then display full image. 


### Improvement Areas:
        a. Test cases are pending.
            
