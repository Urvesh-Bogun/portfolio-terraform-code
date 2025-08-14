import json, boto3

table = boto3.resource("dynamodb").Table("PortfolioTable")

# Add one to the counter and return the updated value
def lambda_handler(event, context):
    r = table.update_item(
        Key={"id": "1"},
        UpdateExpression="ADD view_count :n",
        ExpressionAttributeValues={":n": 1},
        ReturnValues="UPDATED_NEW",
    )
    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps({"views": int(r["Attributes"]["view_count"])}),
    }
