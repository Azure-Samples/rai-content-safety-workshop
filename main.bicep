@description('Specifies the name for Azure Open AI.')
param openaiName string

@description('Specifies the name for Content Safety.')
param contentsafetyName string

param gpt35TurboModelName string = 'gpt-35-turbo'
param textEmbeddingModelName string = 'text-embedding-ada-002'
param chatGptModelVersion string = '0613'
param embeddingDeploymentCapacity int = 10
param chatGptDeploymentCapacity int = 10

@description('Display name of GPT-35-Turbo deployment')
param gpt35TurboDeploymentName string

@description('Display name of Text-Embedding-002 deployment')
param embeddingDeploymentName string

@description('Specifies the location of the Azure Machine Learning workspace and dependent resources.')
@allowed([
  'australiaeast'
  'canadaeast'
  'eastus'
  'eastus2'
  'francecentral'
  'japaneast'
  'southcentralus'
  'switzerlandnorth'
  'uksouth'
  'westcentralus'
  'westus'
  'westeurope'
])
param location string

param oaSKU string = 'S0'
resource account1 'Microsoft.CognitiveServices/accounts@2022-03-01' = {
  name: openaiName
  location: location
  kind: 'OpenAI'
  sku: {
    name: oaSKU
  }
  properties: {
  }
}

param csSKU string = 'S0'
resource contentsafetyaccount 'Microsoft.CognitiveServices/accounts@2022-03-01' = {
  name: contentsafetyName
  location: location
  kind: 'ContentSafety'
  sku: {
    name: csSKU
  }
  properties: {
  }
}



resource gptDeployment 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' =  {
  parent: account1
  name: gpt35TurboDeploymentName
  properties: {
    model: {
         format: 'OpenAI'
         name: gpt35TurboModelName
         version: chatGptModelVersion
        }
  }
  sku:  {
    name: 'Standard'
    capacity: chatGptDeploymentCapacity
  }
}


resource embedDeployment 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' =  {
  parent: account1
  name: embeddingDeploymentName
  properties: {
     model: {
         format: 'OpenAI'
         name: textEmbeddingModelName
         version: '2'
        }   
    
  }
  sku:  {
    name: 'Standard'
    capacity: embeddingDeploymentCapacity
  }
  dependsOn: [
    gptDeployment
  ]
}



