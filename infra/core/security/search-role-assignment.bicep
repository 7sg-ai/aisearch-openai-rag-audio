metadata description = 'Creates a role assignment for a service principal scoped to a search service resource.'
param principalId string
param searchServiceName string
param roleDefinitionId string = '1407120a-92aa-4202-b7e9-c0e197c71c8f' // Search Index Data Reader

@allowed([
  'Device'
  'ForeignGroup'
  'Group'
  'ServicePrincipal'
  'User'
])
param principalType string = 'ServicePrincipal'

// Reference to the search service
resource searchService 'Microsoft.Search/searchServices@2023-11-01' existing = {
  name: searchServiceName
}

// Role assignment scoped to the search service resource
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, resourceGroup().id, searchServiceName, principalId, roleDefinitionId)
  scope: searchService
  properties: {
    principalId: principalId
    principalType: principalType
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
  }
}
