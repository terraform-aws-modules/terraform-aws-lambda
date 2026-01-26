def lambda_handler(event, context):
    import requests

    print("Hello from uv-managed Lambda!")
    return {"statusCode": 200}
