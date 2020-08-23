const AWS = require("aws-sdk")
const crypto = require("crypto")

const documentClient = new AWS.DynamoDB.DocumentClient();
exports.handler = async(event) => {
    const {peso}  = event;
    const params = {
        TableName: "buzon",
        Item: {
            id: new Date().toString(),
            peso: peso
        }
    };
    try {
        const data = await documentClient.put(params).promise();
        return {
            error: false,
            message: 'peso agregado',
            code: 200
        };
    } catch (er) {
        return {
            error: false,
            message: 'Hubo un problema al agregar el peso',
            code: 502
        };
    }
};