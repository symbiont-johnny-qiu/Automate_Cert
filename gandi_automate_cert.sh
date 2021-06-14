#!/bin/bash

## This will help convert CSR file to single-string with proper new-line

format_csr=$(awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' $1)
echo $format_csr

## POST command to create new certificate using billing (sharing_id) and passing in csr file 

dry_run_cert=$(curl POST -v -H "dry-run: 1" -H "Content-Type: application/json" -H "Authorization: Apikey spwGKaMq5UR6ZdN3nHNlsafm" "https://api.gandi.net/v5/certificate/issued-certs?sharing_id=b7d1102c-9566-11e7-9958-00163e6dc886" -d '{"package": "cert_std_1_0_0", "csr": "'"$format_csr"'"}')

## Parses json text to pass in the url for another PATCH command to change dcv method to dns

cert_link=$(echo $dry_run_cert | jq '.href')

curl --request PATCH -v -H "Content-Type: application/json" -H "Authorization: Apikey spwGKaMq5UR6ZdN3nHNlsafm" $cert_link -d '{"method": "dns"}'

## Get the CN to pass to post command to get DCV 
## Fetch the DNS Record after it has been created
cert_cn=$(curl --request GET -v -H "Content-Type: application/json" -H "Authorization: Apikey spwGKaMq5UR6ZdN3nHNlsafm" $cert_link | jq '.cn' | tr -d \")

curl --request POST -H "Content-Type: application/json" -H "Authorization: Apikey spwGKaMq5UR6ZdN3nHNlsafm" https://api.gandi.net/v5/certificate/dcv_params -d '{"cn": "'"$cert_cn"'", "dcv_method": "dns", "csr": "'"$format_csr"'"}'