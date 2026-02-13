metadata description = 'Creates or updates an existing Azure Container App.'
param name string
param location string = resourceGroup().location
param tags object = {}


@description('The number of CPU cores allocated to a single container instance, e.g., 0.5')
param containerCpuCoreCount string = '0.5'

@description('The maximum number of replicas to run. Must be at least 1.')
@minValue(1)
param containerMaxReplicas int = 10

@description('The amount of memory allocated to a single container instance, e.g., 1Gi')
param containerMemory string = '1.0Gi'

@description('The minimum number of replicas to run. Must be at least 1.')
@minValue(1)
param containerMinReplicas int = 1

@description('The name of the container')
param containerName string = 'main'

@description('The environment name for the container apps')
param containerAppsEnvironmentName string = '${containerName}env'

@description('The name of the container registry')
param containerRegistryName string

@description('Hostname suffix for container registry. Set when deploying to sovereign clouds')
param containerRegistryHostSuffix string = 'ecr.amazonaws.com'

// AWS App Mesh uses HTTP/GRPC – keep protocol param but remove Dapr specific naming
param appProtocol string = 'http'

@description('Enable or disable Dapr for the container app')
param daprEnabled bool = false

@description('The Dapr app ID')
param daprAppId string = containerName

@description('Specifies if the resource already exists')
param exists bool = false

@description('Specifies if Ingress is enabled for the container app')
param ingressEnabled bool = true

@description('The type of identity for the resource')
@allowed(['None', 'SystemAssigned', 'UserAssigned'])
param identityType string = 'None'

@description('The name of the user-assigned identity')
param identityName string = ''

@description('The name of the container image')
param imageName string = ''

// AWS Secrets Manager – reference secret ARNs
param secretArns array = []

@description('The keyvault identities required for the container')
@secure()
param keyvaultIdentities object = {}

@description('The environment variables for the container in key value pairs')
param env object = {}

// AWS ALB listener configuration – set public facing flag via LoadBalancer scheme
param albPublic bool = true

@description('The service binds associated with the container')
param serviceBinds array = []

@description('The target port for the container')
param targetPort int = 80

// AWS Fargate CPU/Memory combos – define via task definition resources
param cpu string = '256' // 0.25 vCPU
param memory string = '512' // 0.5 GB
param workloadProfile string = 'Consumption'

param allowedOrigins array = []

// AWS ECS Service – use AWS::ECS::Service (or CDK construct) instead of Azure Container Apps
  name: name
}

module app 'container-app.bicep' = {
  name: '${deployment().name}-update'
  params: {
    name: name
    workloadProfile: workloadProfile
    location: location
    tags: tags
    identityType: identityType
    identityName: identityName
    ingressEnabled: ingressEnabled
    containerName: containerName
    containerAppsEnvironmentName: containerAppsEnvironmentName
    containerRegistryName: containerRegistryName
    containerRegistryHostSuffix: containerRegistryHostSuffix
    containerCpuCoreCount: containerCpuCoreCount
    containerMemory: containerMemory
    containerMinReplicas: containerMinReplicas
    containerMaxReplicas: containerMaxReplicas
    daprEnabled: daprEnabled
    daprAppId: daprAppId
    daprAppProtocol: daprAppProtocol
    secrets: secrets
    keyvaultIdentities: keyvaultIdentities
    allowedOrigins: allowedOrigins
    external: external
    env: [
      for key in objectKeys(env): {
        name: key
        value: '${env[key]}'
      }
    ]
    imageName: !empty(imageName) ? imageName : exists ? existingApp.properties.template.containers[0].image : ''
    targetPort: targetPort
    serviceBinds: serviceBinds
  }
}

output defaultDomain string = app.outputs.defaultDomain
output imageName string = app.outputs.imageName
output name string = app.outputs.name
output uri string = app.outputs.uri
output id string = app.outputs.id
output identityPrincipalId string = app.outputs.identityPrincipalId
