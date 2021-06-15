# Automate_Cert

Purpose of the script is to use Gandi API to automate SSL certificate creation and apply changes directly to AWS 


## Getting Started

### Dependencies
* Must have 'jq' package installed for parsing JSON in script
* Please have boto downloaded as well with the right credentials in ~./aws 

### Executing program
* Make sure you have the necessary permissions to run script 
```
chmod u+x gandi_automate.sh
``` 
* Pass in the CSR file that you want to generate a cert with and the script will output the necessary information in the process , timer has been set to around ~5 minutes for creation/validation of cert  to take place.
EX:
```
./gandi_automate.sh ledger-XXX.csr
```
