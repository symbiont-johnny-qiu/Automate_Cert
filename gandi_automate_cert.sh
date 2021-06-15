#!/bin/bash

## This will help convert CSR file to single-string with proper new-line

format_csr=$(awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' $1)
echo -e "\nThis is the converted CSR String : \n\n" $format_csr

## POST command to create new certificate using billing (sharing_id) and passing in csr file 
# $(curl POST -v -H "dry-run: 1" -H "Content-Type: application/json" -H "Authorization: Apikey spwGKaMq5UR6ZdN3nHNlsafm" "https://api.gandi.net/v5/certificate/issued-certs?sharing_id=b7d1102c-9566-11e7-9958-00163e6dc886" -d '{"package": "cert_std_1_0_0", "csr": "'"$format_csr"'"}')
## Parses json text to pass in the url for another PATCH command to change dcv method to dns
echo -e "\nInitiating POST command to create new cert .........\n"
cert_link=$(curl -X POST -H "Content-Type: application/json" -H "Authorization: Apikey spwGKaMq5UR6ZdN3nHNlsafm" "https://api.gandi.net/v5/certificate/issued-certs?sharing_id=b7d1102c-9566-11e7-9958-00163e6dc886" -d '{"package": "cert_std_1_0_0", "csr": "'"$format_csr"'"}'| jq '.href')

## Adding a timer for Gandi to validate contact validation step
echo -e "\n Script is not finish(Do not interrupt),please wait for 5 minutes to allow Gandhi to process contact validation\n"
sleep 5m
echo $cert_link
patch_cert=$(echo $cert_link| tr -d \" )"/dcv"
echo -e "\nChanging DCV method to DNS ........\n"
curl -X PATCH -H "Content-Type: application/json" -H "Authorization: Apikey spwGKaMq5UR6ZdN3nHNlsafm" $patch_cert -d '{"method": "dns"}'
echo -e "\nGetting Validation Records via DNS ........\n"

## Fetch the DNS Record after it has been created
get_dns=$(curl -X POST -H "Content-Type: application/json" -H "Authorization: Apikey spwGKaMq5UR6ZdN3nHNlsafm" https://api.gandi.net/v5/certificate/dcv_params -d '{"dcv_method": "dns", "csr": "'"$format_csr"'"}'| jq '.messages')
echo -e "\nThe DNS Record: \n" $get_dns

## Now pass it to AWS to automate the cert
get_record_name=$(echo $get_dns | awk '{print $8}')
get_record_value=$(echo $get_dns | awk '{print $12}' | sed 's/"//')
## Get the record name and value to pass it to python script
echo -e "\nThe record name is :" $get_record_name 
echo -e "\nThe record value is :" $get_record_value

#Pass parameters to python file
Route53_add_record.py $get_record_name $get_record_value



