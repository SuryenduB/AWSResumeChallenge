import boto3
import json

def lambda_handler(event, context):
    dynamodb = boto3.client('dynamodb')
    table_name = 'visitorscount'  # Replace with your actual table name
    number_to_update_s = '0'
    

    # Scan the table to retrieve all items
    response = dynamodb.scan(TableName=table_name)
    
    # Fetch the item with partition key 'count' equal to '9'
    try:
        get_response = dynamodb.get_item(
            TableName=table_name,
            Key={
                'id': {'S': '1'}  # Assuming 'count' is a numeric attribute
            }
        )
        item = get_response.get('Item')
        if item:
            itemcount = int(item['count']['S'])
            number_to_update = itemcount + 1
            number_to_update_s = str(number_to_update)
            print(f"Item retrieved: {number_to_update}")
        else:
            print("Item not found.")
    except Exception as e:
        print(f"Error fetching item: {e}")

    #return "GetItem operation completed."
    
      

    # Update the item in DynamoDB
    item = {
    'id': {'S': '1'},  # Replace 'your_id_value' with the actual ID value
    'count': {'S': number_to_update_s}  # Replace 'other_value' with the actual attribute value
}
    response = dynamodb.put_item(
    TableName=table_name,
    Item=item
)



    return {
        'statusCode': 200,
        'headers': {
            
            'Access-Control-Allow-Origin': '*',
            
        },
        'body': json.dumps(f"{number_to_update_s}")
        
    }
