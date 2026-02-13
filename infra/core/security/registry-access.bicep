metadata description = 'Assigns ACR Pull permissions to access an Azure Container Registry.'
param containerRegistryName string
param principalId string

# AWS IAM policy ARN for ECR read‑only access (e.g., arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly)

# AWS IAM Role and Policy for ECR pull (e.g., AWS::IAM::Role with AmazonEC2ContainerRegistryReadOnly managed policy)
  # AWS does not scope IAM role to a specific ECR repository; permissions are granted via the attached policy
  name: guid(subscription().id, resourceGroup().id, principalId, acrPullRole)
  properties: {
    roleDefinitionId: acrPullRole
    principalType: 'ServicePrincipal'
    principalId: principalId
  }
}

# Reference to existing AWS ECR repository (e.g., using AWS::ECR::Repository or import via ARN)
  name: containerRegistryName
}
