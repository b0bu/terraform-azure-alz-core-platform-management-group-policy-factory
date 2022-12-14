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

  # templated_map_of_policy_parameter_files = try(length(local.list_of_policy_parameter_files) > 0, false) ? {
  #   for filepath in local.list_of_policy_parameter_files :
  #   filepath => jsondecode(templatefile("${local.templates_path}/${filepath}", local.common_template_values))
  # } : null

  # templated_map_of_policy_parameter_files = try(length(local.list_of_policy_parameter_files) > 0, false) ? [
  #   for filepath in local.list_of_policy_parameter_files : jsondecode(templatefile("${local.templates_path}/${filepath}", local.common_template_values))
  #  ] : null
}

// built ins do not require creation only deployment
locals {
  archetypes = {
    root = {
      builtin = [
          {
            name =  "NIST-SP-800-53-rev-5"
            id = "/providers/Microsoft.Authorization/policySetDefinitions/179d1daa-458f-4e47-8086-2a68d0d6c38f"
          },
          {
            name = "CIS-Benchmark-v1.4.0"
            id = "/providers/Microsoft.Authorization/policySetDefinitions/c3f5c4d9-9a1d-4a99-85c0-7f93e384d5c5"
          }
      ]
    }
  }
}

output "initiatives" {
  value = local.templated_map_of_policy_initiative_files
}

output "definitions" {
  value = local.templated_map_of_policy_definition_files
}

output "builtin_definitions" {
  value = local.archetypes[var.archetype].builtin
}

output "parameters" {
  value = local.template_parameters_for_policy_assignement
}