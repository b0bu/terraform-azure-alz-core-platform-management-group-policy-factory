// dynamically generated custom policy by file => definition metadata
locals {
  archetype = var.archetype

  templates_path                 = "${path.module}/policies/parameters"
  list_of_policy_parameter_files = tolist(fileset(local.templates_path, "**.json"))

  // file path to search based on archetype
  initiatives_path = "${path.module}/policies/${local.archetype}/initiatives"
  definitions_path = "${path.module}/policies/${local.archetype}/definitions"

  /*
  The order of this list is maintained in the state, this is done so that an accurate mapping of
  policy name, whether it needs a managed identity, to which roles that managed id required.
  The only thing to note here is that newly added files should be pushed onto the end of the list,
  not in the middle and not at the top. This is a low friction caveat to being able to massively
  and quickly scale policy.
  */
  list_of_policy_initiative_files = [
    "deploy_mdfc_config.json",
    "enforce_encrypt_in_transit.json",
    "deploy-resource-diag.json",
  ]

  list_of_policy_definition_files = tolist(fileset(local.definitions_path, "**.json"))

  // ignored if no templating is required; uses ${} syntax within .json tmpl
  // build out for when var interoplation is required in params or policy
  common_template_values = {
    scope    = var.scope
    location = "uksouth"
  }

  /*
  using this structure controls the managed identity of a policy initiatives or definitions 
  which has a file on disk, exist in entirely in memory or are builtins
  provided by azure policy.

  no entry means a managed identity will not be created

  emtpy entries will assign policy with a managed identity this is required when a policy
  has a default value of DeployIfNotExists and some will need it

  otherwise at role assignment the managed identity will be assigned a role for each role in the list
  */
  managed_identity_role_assignments = {
    Deploy-MDFC-Config     = ["Security Admin", "Contributor"]
    NIST-SP-800-53-rev-5   = []
    Enforce-EncryptTransit = []
    Deploy-Resource-Diag   = ["Monitor Contributor", "Log Analytics Contributor"]
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

output "managed_identity_role_assignments" {
  value = local.managed_identity_role_assignments
}

output "parameters" {
  value = local.template_parameters_for_policy_assignement
}

output "list_of_policy_initiative_file_names" {
  value = local.list_of_policy_initiative_files
}