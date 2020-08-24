const AWS = require("aws-sdk")
const documentClient = new AWS.DynamoDB.DocumentClient();
exports.handler = function(event, ctx, callback) {
    const params = {
        TableName: "buzon3",
        ScanIndexForward: "false",
        Limit: 5,
        //Select: "SPECIFIC_ATTRIBUTES",
        //ProjectionExpression: "#F,#S",
        KeyConditionExpression : "#id = :id",
        ExpressionAttributeNames: {
        "#id":"id"},
        ExpressionAttributeValues : {
            ':id' : 1
        }
    };
    documentClient.query(params, function(err, data){
        if(err){
            callback(err, null);
        }else{
            callback(null, data);
        }
    });
}