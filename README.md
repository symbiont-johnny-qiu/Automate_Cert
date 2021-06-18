# Automate_Create_Gandi_SSLCert

Purpose of the script is to use Gandi API to automate SSL certificate creation and apply changes directly to AWS 


## Getting Started
* Quick note : Hosted Zone in Route53_add_record.py should be changed depending on the zone you want to create the record 
* A sleep timer is set to two minutes for validating credentials, it is important not to interrupt this process during the script 

### Dependencies
* Must have 'jq' package installed for parsing JSON in script. Link to jq documentation and install instructions https://stedolan.github.io/jq/download/
* Please have python boto module downloaded as well with the right credentials in ~./aws 

### Executing program
* Make sure you have the necessary permissions to run script 
```
chmod u+x gandi_automate.sh
``` 
* Pass in the CSR file that you want to generate a cert with and the script will apply changes while outputting the necessary information in the process , timer has been set to around ~5 minutes for creation/validation of cert  to take place.
</br>EX:
```
./gandi_automate.sh ledger-XXX.csr
```
Depending on the python version you are using ex : python3 python2.9 .. etc you can change on the script to fit your needs
```
EX: python3.9 Route53_add_record.py
```



