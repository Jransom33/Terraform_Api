import { APIGatewayEvent, APIGatewayProxyResult } from 'aws-lambda';
import { DeleteItemCommand, DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { marshall } from '@aws-sdk/util-dynamodb';
const dynamoDbRemoveConnection = async ( connectionId: string) => {
    const dynamodb = new DynamoDBClient({ region: process.env.AWS_REGION });
    const tableName = process.env.TABLE_NAME;
    try {
        const params: any = {
            TableName: tableName,
            Key: {
                'connectionId': marshall(connectionId)
            }
        };
        const command = new DeleteItemCommand(params);
        // Call DynamoDB to add connection
        const result = await dynamodb.send(command);

        return result;
    } catch(e) {
        if (e instanceof Error) {
            return e
        }
        return new Error(`dynamoDbAddConnection error object unknown type`);
    }
}

export const handler = async (event: APIGatewayEvent) => {
    const connectionId = event.requestContext.connectionId;
    console.log('attempt user:', connectionId)
    //Checing if connectionId actually exists and has a value
    if (!connectionId) {
        return {
            statusCode: 400,
            body: "Connection ID not provided"
        };
    }

    const res = await dynamoDbRemoveConnection(connectionId);
    //error handling of dynamoDbRemoveConnection
    if (res instanceof Error) {
        console.log('error', res.message)
        return {
            "statusCode" : 500,
            "headers" : {
                "content-type": "text/plain; charset=utf-8"
            },
            "body" : res.message
        }
    }

    console.log('removed!');
    
    return {
        statusCode: 200,
        body: JSON.stringify({
            message: `User ${connectionId} removed!`,
        }),
    };
};