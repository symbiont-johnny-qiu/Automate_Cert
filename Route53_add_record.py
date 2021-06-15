import boto3
import sys  

client = boto3.client('route53')
try :
## Doing change batches for creating new dns record
    response = client.change_resource_record_sets(
        HostedZoneId = 'Z05023012PPJJ1SFDTC0F',
        ChangeBatch = {
            'Comment': 'Creating DNS record from Gandi',
            'Changes': [
                {
                    'Action': 'UPSERT',
                    'ResourceRecordSet': {
                        'Name': sys.argv[1],
                        'Type': 'CNAME',
                        'TTL': 300,
                        'ResourceRecords': [
                            {
                                'Value': sys.argv[2]
                            }]

                    }
                }
            ]
        }
    )
    print (f" \n AWS Record has been created/updated for {sys.argv[1]}\n")
except IndexError:
    print(f"\nError encountered please check if parameters passed in is empty\n")


