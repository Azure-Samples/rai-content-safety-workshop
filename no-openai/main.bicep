@description('Specifies the name for Content Safety.')
param contentsafetyName string

@description('Specifies the location of the Azure Machine Learning workspace and dependent resources.')
@allowed([
  'australiaeast'
  'brazilsouth'
  'canadacentral'
  'centralus'
  'eastasia'
  'eastus'
  'eastus2'
  'francecentral'
  'japaneast'
  'koreacentral'
  'northcentralus'
  'northeurope'
  'southeastasia'
  'southcentralus'
  'uksouth'
  'westcentralus'
  'westus'
  'westus2'
  'westeurope'
  'usgovvirginia'
  'southafricanorth'
  'southafricawest'
])
param location string


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
output contentsafetyApiKey string = contentsafetyaccount.listKeys().key1
