include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/asklepi-com/asklepi-github-bootstrapper.git//modules/github-repository?ref=v1.1.1"
}

inputs = {
  repo_name = "asklepi-core-infra"

  teams = {
    asklepi_platform_engineers = {
      slug       = "asklepi-platform-engineers"
      permission = "push"
    }
  }

  branch_protection_rules = {
    main = {
      pattern                         = "main"
      enforce_admins                  = false
      require_signed_commits          = true
      dismiss_stale_reviews           = true
      require_conversation_resolution = true
      restrict_push_access            = false
      push_restrictions_teams         = ["asklepi-platform-engineers"]
      require_code_owner_reviews      = true
      required_approving_review_count = 1
      required_status_checks          = true
      required_status_check_contexts  = ["validate"]
      strict_status_checks            = true
    }
  }

  codeowners = {
    "*" = ["@asklepi-com/asklepi-platform-engineers"]
  }

  write_repository_actions_variables = false
  manage_repository_settings         = true
  delete_branch_on_merge             = true
}
