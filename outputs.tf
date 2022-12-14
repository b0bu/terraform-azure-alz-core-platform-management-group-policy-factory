// dynamically generated custom policy by file => definition metadata
locals {
  scope                           = var.scope
  archetype                       = var.archetype
  location                        = "uksouth"

  templates_path = "${path.module}/policies/parameters"
  list_of_policy_parameter_files = tolist(fileset(local.templates_path, "**.json"))

  // file path to search based on archetype
  initiatives_path                = "${path.module}/policies/${local.archetype}/initiatives"
  definitions_path                = "${path.module}/policies/${local.archetype}/definitions"
  list_of_policy_initiative_files = tolist(fileset(local.initiatives_path, "**.json"))
  list_of_policy_definition_files = tolist(fileset(local.definitions_path, "**.json"))

  // ignored if no templating is required; uses ${} syntax within .json tmpl
  // build out for when var interoplation is required in params or policy
  common_template_values = {
    scope    = local.scope
    location = local.location
  }

  // categorise policy assignment by if managed identity is required or not
  // an entry here means an initiative will be assigned with a managed identity
  azurerm_role_assignments = {
    Deploy-MDFC-Config     = ["Security Admin", "Contributor"]
    NIST-SP-800-53-rev-5   = [] # assign with managed identity but no role assignments included
    Enforce-EncryptTransit = []
    //Deploy-ASC-SecContacts = [] this should not be being assigned it's assigned inside of MDFC
  }

  // json to HCL or null
  templated_map_of_policy_initiative_files = try(length(local.list_of_policy_initiative_files) > 0, false) ? {
    for filepath in local.list_of_policy_initiative_files :
    filepath => jsondecode(templatefile("${local.initiatives_path}/${filepath}", local.common_template_values))
  } : null

  // json to HCL or null
  templated_map_of_policy_definition_files = try(length(local.list_of_policy_definition_files) > 0, false) ? {
    for filepath in local.list_of_policy_definition_files :
    filepath => jsondecode(templatefile("${local.definitions_path}/${filepath}", local.common_template_values))
  } : null

}


output "initiatives" {
  value = local.templated_map_of_policy_initiative_files
}

output "definitions" {
  value = local.templated_map_of_policy_definition_files
}

output "azurerm_role_assignments" {
  value = local.azurerm_role_assignments
}

output "parameters" {
  value = local.template_parameters_for_policy_assignement
}