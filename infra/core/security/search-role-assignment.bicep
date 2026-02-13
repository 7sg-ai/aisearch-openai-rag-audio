metadata description = 'Creates a role assignment for a service principal scoped to a search service resource.'
param principalId string
param searchServiceName string
param roleDefinitionId string = 'arn:aws:iam::aws:policy/AmazonOpenSearchServiceReadOnlyAccess' // AWS OpenSearch read‑only policy

@allowed([
  'Device'
  'ForeignGroup'
  'Group'
  'ServicePrincipal'
  'User'
])
param principalType string = 'ServicePrincipal'

// Reference to the search service
# Reference to existing AWS OpenSearch Service domain (e.g., using AWS::OpenSearchService::Domain ARN)
  name: searchServiceName
}

// Role assignment scoped to the search service resource
# AWS IAM Policy for OpenSearch read access (e.g., AWS::IAM::Policy attached to a role with arn:aws:iam::aws:policy/AmazonOpenSearchServiceReadOnlyAccess)
  name: guid(subscription().id, resourceGroup().id, searchServiceName, principalId, roleDefinitionId)
  # AWS IAM policies are not scoped via a separate property; include the OpenSearch domain ARN in the policy's Resource element
  properties: {
    principalId: principalId
    principalType: principalType
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
  }
}
