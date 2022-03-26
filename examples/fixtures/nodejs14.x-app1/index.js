'use strict';

module.exports.hello = async (event) => {
  console.log(event);
  return {
    statusCode: 200,
    body: JSON.stringify(
      {
        message: `Go Serverless v3.0! Your Nodejs function executed successfully!`,
        input: event,
      },
      null,
      2
    ),
  };
};
