import boto3
import sys  

client = boto3.client('route53')

## Doing change batches for creating new dns record

response = client.change_resource_record_sets(
    HostedZoneId = 'Z05023012PPJJ1SFDTC0F',
    ChangeBatch = {
        'Comment': 'Creating DNS record from Gandi',
        'Changes': [
            {
                'Action': 'UPSERT',
                'ResourceRecordSet': {
                    'Name': '_37324B81E33C7AF8C2E7F48859C59F2D.ledger-jqiu-node-smoketest-today.release.symdev.us.',
                    'Type': 'CNAME',
                    'TTL': 300,
                    'ResourceRecords': [
                        {
                            'Value': '15D6A43AFA2692E669214A2615D90602.7CD00F3B157FB7FEDFCFC9595C6EE0D6.d740de1e79667d117d8d.comodoca.com.'
                        }]

                }
            }
        ]
    }
)

print (f" \n AWS Record has been created/updated for {sys.argv[1]}\n")
