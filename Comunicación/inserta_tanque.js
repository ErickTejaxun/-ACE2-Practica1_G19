const AWS = require("aws-sdk")

const documentClient = new AWS.DynamoDB.DocumentClient();
exports.handler = async(event) => {
    const {tanque}  = event;
    const params = {
        TableName: "tanque",
        Item: {
            id: new Date().toString(),
            llenado: tanque
        }
    };
    try {
        const data = await documentClient.put(params).promise();
        return {
            error: false,
            message: 'medida agregado',
            code: 200
        };
    } catch (er) {
        return {
            error: false,
            message: 'Hubo un problema al agregar la medida',
            code: 502
        };
    }
};