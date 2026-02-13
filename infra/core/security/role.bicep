metadata description = 'Creates a role assignment for a service principal.'
param principalId string

@allowed([
  'Device'
  'ForeignGroup'
  'Group'
  'ServicePrincipal'
  'User'
])
param principalType string = 'ServicePrincipal'
param roleDefinitionId string

# AWS IAM PolicyAttachment (e.g., AWS::IAM::PolicyAttachment) linking the principal to the desired managed or custom policy
  name: guid(subscription().id, resourceGroup().id, principalId, roleDefinitionId)
  properties: {
    principalId: principalId
    principalType: principalType
    # AWS uses IAM policy ARN; replace with appropriate ARN or managed policy name (e.g., arn:aws:iam::aws:policy/YourPolicy)
  }
}
