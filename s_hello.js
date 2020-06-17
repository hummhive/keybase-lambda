
var serverlessSDK = require('./serverless_sdk/index.js');
serverlessSDK = new serverlessSDK({
  orgId: 'thedavidmeister',
  applicationName: 'keybase-lambda-app',
  appUid: 'jgk1242bpz6lpWB7qT',
  orgUid: 'gQtZqXTyc4yRHZZW78',
  deploymentUid: 'e4a6cd31-b1ca-4cdc-bdbf-65406e30823c',
  serviceName: 'keybase-lambda',
  shouldLogMeta: true,
  shouldCompressLogs: true,
  disableAwsSpans: false,
  disableHttpSpans: false,
  stageName: 'dev',
  serverlessPlatformStage: 'prod',
  devModeEnabled: false,
  accessKey: null,
  pluginVersion: '3.6.13',
  disableFrameworksInstrumentation: false
});

const handlerWrapperArgs = { functionName: 'keybase-lambda-dev-hello', timeout: 6 };

try {
  const userHandler = require('./handler.js');
  module.exports.handler = serverlessSDK.handler(userHandler.hello, handlerWrapperArgs);
} catch (error) {
  module.exports.handler = serverlessSDK.handler(() => { throw error }, handlerWrapperArgs);
}