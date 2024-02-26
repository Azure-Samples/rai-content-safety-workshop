@description('Specifies the name for Azure Open AI.')
param openaiName string

@description('Specifies the name for Content Safety.')
param contentsafetyName string

param gpt35TurboModelName string = 'gpt-35-turbo'
param textEmbeddingModelName string = 'text-embedding-ada-002'
param embeddingDeploymentCapacity int = 5
param chatGptDeploymentCapacity int = 5

param csExists bool = false
param openaiExists bool = false

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

param oldRegion array = [
  'westeurope' 
  'francecentral'
  'southcentralus'
  ]
param chatGptModelVersion string = contains(oldRegion, location) ? '0301' : '0613' 

param oaSKU string = 'S0'
resource account1 'Microsoft.CognitiveServices/accounts@2022-03-01' = if (!openaiExists) {
  name: openaiName
  location: location
  kind: 'OpenAI'
  sku: {
    name: oaSKU
  }
  properties: {
    customSubDomainName: openaiName
  }
}

param csSKU string = 'S0'
resource contentsafetyaccount 'Microsoft.CognitiveServices/accounts@2022-03-01' = if (!csExists) {
  name: contentsafetyName
  location: location
  kind: 'ContentSafety'
  sku: {
    name: csSKU
  }
  properties: {
    customSubDomainName: contentsafetyName
  }
}



resource gptDeployment 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' = {
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


resource embedDeployment 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' = {
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

output openAIServiceName string = openaiName
output gptDeploymentName string =  gpt35TurboDeploymentName
output textEmbedDeploymentName string = embeddingDeploymentName 

output openAiApiEndpoint string = account1.properties.endpoint
#disable-next-line outputs-should-not-contain-secrets
output openAiApiKey string = account1.listKeys().key1
output contentsafetyEndpoint string = contentsafetyaccount.properties.endpoint
#disable-next-line outputs-should-not-contain-secrets
output contentsafetyApiKey string = contentsafetyaccount.listKeys().key1
