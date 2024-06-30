import logging
import boto3
import os
from uuid import uuid4

# See https://docs.aws.amazon.com/lambda/latest/dg/python-logging.html
logger = logging.getLogger()
logger.setLevel(logging.INFO)

logging.getLogger("boto3").setLevel(logging.DEBUG)
logging.getLogger("botocore").setLevel(logging.DEBUG)

bucketName = os.environ["BUCKET_NAME"]
regionName = os.environ["REGION_NAME"]


def lambda_handler(event, context):
    client = boto3.client("s3", regionName)
    response = client.put_object(
        Bucket=bucketName, Key=str(uuid4()), Body=bytearray("Hello, World!", "utf-8")
    )

    logger.info(response)

    return response
