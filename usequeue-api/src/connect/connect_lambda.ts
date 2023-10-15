import { DynamoDBClient, PutItemCommand } from '@aws-sdk/client-dynamodb';
import { APIGatewayEvent } from 'aws-lambda';
import { marshall, unmarshall } from '@aws-sdk/util-dynamodb';



const addConnection = async ( connectionId: string) => {
    const dynamodb = new DynamoDBClient({ region: process.env.AWS_REGION });
    const tableName = process.env.TABLE_NAME;
    const params = {
        TableName: tableName,
        Item: marshall({
            connectionId: connectionId,
            // You can store additional metadata if needed, e.g., timestamp, user info, etc.
        }),
    };
    const command  = new PutItemCommand(params);

    return dynamodb.send(command);
};

export const handler = async (event: APIGatewayEvent) => {
    const connectionId = event.requestContext.connectionId;
    if (!connectionId) {
        return {
            statusCode: 400,
            body: "Connection ID not provided"
        };
    }
    await addConnection(connectionId);

    return {
        statusCode: 200,
        body: "Connection stored"
    };
};
