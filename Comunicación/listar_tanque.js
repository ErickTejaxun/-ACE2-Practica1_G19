const AWS = require("aws-sdk")
const documentClient = new AWS.DynamoDB.DocumentClient();
exports.handler = async(event) => {
    const params = {
        TableName: "tanque",
        ExpressionAttributeNames: {
        "#S": "llenado"},
        Select: "SPECIFIC_ATTRIBUTES",
        ProjectionExpression: "#S", 
        ScanIndexForward: true
    };
    try {
        const data = await documentClient.scan(params).promise();
        return {
            error: false,
            message: 'lista de llenado',
            data: data,
            code: 200
        };
    } catch (er) {
        return {
            error: true,
            message: 'Hubo un problema al obtener el llenado',
            code: 502
        };
    }
};