const AWS = require("aws-sdk")
const documentClient = new AWS.DynamoDB.DocumentClient();
exports.handler = async(event) => {
    const params = {
        TableName: "buzon",
        ExpressionAttributeNames: {
        "#S": "peso"},
        Select: "SPECIFIC_ATTRIBUTES",
        ProjectionExpression: "#S", 
        ScanIndexForward: true
    };
    try {
        const data = await documentClient.scan(params).promise();
        return {
            error: false,
            message: 'lista de pesos',
            data: data,
            code: 200
        };
    } catch (er) {
        return {
            error: true,
            message: 'Hubo un problema al obtener el peso',
            code: 502
        };
    }
};