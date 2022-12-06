// idea is at a glance you can see which polices are applied to which scopes
locals {
  archetypes = {
    root = {
      # for filepath in fileset("${path.module}/policy/root", "*"):
      #   trim(filepath, ".json") => filepath
      baseline_policy = {
        requires_identity = {
            "NIST SP 800-53 rev. 5" = "/providers/Microsoft.Authorization/policySetDefinitions/179d1daa-458f-4e47-8086-2a68d0d6c38f"
        }
        no_required_identity = {}
      }
      custom_policy = {}
    }
    platform = {
      baseline_policy = {
        requires_identity = {}
        no_required_identity = {}
      }
      custom_policy = {}
    }
    identity = {
      baseline_policy = {
        requires_identity = {}
        no_required_identity = {}
      }
      custom_policy = {}
    }
    management = {
      baseline_policy = {
        requires_identity = {}
        no_required_identity = {}
      }
      custom_policy = {}
    }
    connectivity = {
      baseline_policy = {
        requires_identity = {}
        no_required_identity = {}
      }
      custom_policy = {}
    }
    landingzones = {
      baseline_policy = {
        requires_identity = {}
        no_required_identity = {}
      }
      custom_policy = {}
    }
    corp = {
      baseline_policy = {
        requires_identity = {}
        no_required_identity = {}
      }
      custom_policy = {}
    }
    online = {
      baseline_policy = {
        requires_identity = {}
        no_required_identity = {}
      }
      custom_policy = {}
    }
    decommissioned = {
      baseline_policy = {
        requires_identity = {}
        no_required_identity = {}
      }
      custom_policy = {}
    }
    sandboxes = {
      baseline_policy = {
        requires_identity = {}
        no_required_identity = {}
      }
      custom_policy = {}
    }
  }
}

output "baseline_policy" {
  value = local.archetypes[var.archetype].baseline_policy
}

output "custom_policy" {
  value = local.archetypes[var.archetype].custom_policy
}