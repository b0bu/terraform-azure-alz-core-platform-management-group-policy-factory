locals {
  // could templates be pulled off of disk and encoded for ease and less lines??
  // template paramaters for policy by name, to apply at assignment time
  template_parameters_for_policy_assignement = {
    Deploy-MDFC-Config = {
      params = {
        ascExportResourceGroupLocation = {
          value = "uksouth"
        }
        ascExportResourceGroupName = {
          value = "testing-law-MDFC-assignment"
        }
        emailSecurityContact = {
          value = "consoto@microsoft.com"
        }
        enableAscForAppServices = {
          value = "DeployIfNotExists"
        }
        enableAscForArm = {
          value = "DeployIfNotExists"
        }
        enableAscForContainers = {
          value = "DeployIfNotExists"
        }
        enableAscForDns = {
          value = "DeployIfNotExists"
        }
        enableAscForKeyVault = {
          value = "DeployIfNotExists"
        }
        enableAscForOssDb = {
          value = "DeployIfNotExists"
        }
        enableAscForServers = {
          value = "DeployIfNotExists"
        }
        enableAscForSql = {
          value = "DeployIfNotExists"
        }
        enableAscForSqlOnVm = {
          value = "DeployIfNotExists"
        }
        enableAscForStorage = {
          value = "DeployIfNotExists"
        }
        logAnalytics = {
          value = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/resource-group-name/providers/Microsoft.OperationalInsights/worksapces/law-name"
        }
      }
    }
    Deploy-Resource-Diag = {
      params = {
        logAnalytics = {
          value = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/resource-group-name/providers/Microsoft.OperationalInsights/worksapces/law-name"
        }
      }
    }
    Deploy-ASC-SecContacts = {
      params = {
        emailSecurityContact = {
          value = "contoso@microsoft.com"
        }
      }
    }
  }
}

