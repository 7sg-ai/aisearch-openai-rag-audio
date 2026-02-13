metadata description = 'Creates an Azure Container Registry and an Azure Container Apps environment.'
param name string
param location string = resourceGroup().location
param tags object = {}

param containerAppsEnvironmentName string
param containerRegistryName string
param containerRegistryResourceGroupName string = ''
param containerRegistryAdminUserEnabled bool = false
// Replace Azure Log Analytics Workspace with AWS CloudWatch Log Group ARN
param cloudWatchLogGroupArn string
// Replace Azure VNet Subnet ID with AWS Subnet ID
param subnetId string = ''
// AWS uses compute types like FARGATE or EC2; adjust accordingly
param workloadProfile string = 'FARGATE'

var workloadProfiles = workloadProfile == 'Consumption'
  ? [
      {
        name: 'Consumption'
        workloadProfileType: 'Consumption'
      }
    ]
  : [
      {
        name: 'Consumption'
        workloadProfileType: 'Consumption'
      }
      {
        minimumCount: 0
        maximumCount: 2
        name: workloadProfile
        workloadProfileType: workloadProfile
      }
    ]

@description('Optional user assigned identity IDs to assign to the resource')
param userAssignedIdentityResourceIds array = []

// Replace Azure Container Apps Managed Environment with AWS ECS Cluster
module containerAppsEnvironment 'aws-cdk-lib/aws-ecs:Cluster' = {
  name: '${name}-container-apps-environment'
  params: {
    // Required parameters
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceResourceId

    managedIdentities: empty(userAssignedIdentityResourceIds) ? {
      systemAssigned: true
    } : {
      userAssignedResourceIds: userAssignedIdentityResourceIds
    }

    name: containerAppsEnvironmentName
    // Non-required parameters
    infrastructureResourceGroupName: containerRegistryResourceGroupName
    infrastructureSubnetId: virtualNetworkSubnetId
    location: location
    tags: tags
    zoneRedundant: false
    workloadProfiles: workloadProfiles
  }
}

// Replace Azure Container Registry with AWS ECR Repository
module containerRegistry 'aws-cdk-lib/aws-ecr:Repository' = {
  name: '${name}-container-registry'
  scope: resourceGroup(!empty(containerRegistryResourceGroupName) ? containerRegistryResourceGroupName : resourceGroup().name)
  params: {
    name: containerRegistryName
    location: location
    acrAdminUserEnabled: containerRegistryAdminUserEnabled
    tags: tags
  }
}

output defaultDomain string = containerAppsEnvironment.outputs.defaultDomain
output environmentName string = containerAppsEnvironment.outputs.name
output environmentId string = containerAppsEnvironment.outputs.resourceId

output registryLoginServer string = containerRegistry.outputs.loginServer
output registryName string = containerRegistry.outputs.name
