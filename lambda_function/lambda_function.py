import json
import boto3
import base64

s3 = boto3.client('s3')
rekognition = boto3.client('rekognition', 'us-east-1')

def lambda_handler(event, context):
    name = event['name']
    image = event['image']
    image = image[image.find(",")+1:]
    dec = base64.b64decode(image + "===")
    s3.put_object(Bucket='waste-analyzer', Key=name, Body=dec)
    response = rekognition.detect_labels(
        Image={
            'S3Object': {
                'Bucket': 'waste-analyzer',
                'Name': name,
            }
        },
        MaxLabels=10,
        MinConfidence=90,
    )
    
    return {'statusCode': 200, 'body': response, 'headers': {'Access-Control-Allow-Origin': '*'}} 
        