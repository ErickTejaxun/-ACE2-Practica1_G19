const AWS = require("aws-sdk")
var rightNow = new Date();
var res = rightNow.toISOString().slice(0,10).replace(/-/g,"");
const documentClient = new AWS.DynamoDB.DocumentClient();

exports.handler = async(event) => {
    const {peso}  = event;
    const params = {
        TableName: "buzon3",
        Item: {
            id: 1,
            fecha:parseInt((new Date()).toISOString().replace(/[^0-9]/g, "")),
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
            message: 'Hubo un problema al agregar el peso' + er,
            code: 502
        };
    }
};