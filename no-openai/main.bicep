@description('Specifies the name for Content Safety.')
param contentsafetyName string

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

param csSKU string = 'S0'
resource contentsafetyaccount 'Microsoft.CognitiveServices/accounts@2022-03-01' = {
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

output contentsafetyEndpoint string = contentsafetyaccount.properties.endpoint
#disable-next-line outputs-should-not-contain-secrets
output contentsafetyApiKey string = contentsafetyaccount.listKeys().key1
