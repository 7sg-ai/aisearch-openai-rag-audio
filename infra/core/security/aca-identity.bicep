param identityName string
param location string

resource webIdentity 'AWS::IAM::Role' = {
  name: identityName
  location: location
}

output roleArn string = webIdentity.Arn
// clientId not applicable in AWS
