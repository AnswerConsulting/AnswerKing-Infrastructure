variable "permission_sets" {
  description = <<EOT
    List of permission sets for the organization.
    
    • `name`             - (Optional) The name of the Permission Set. The key will be used by default.
    • `description`      - (Optional) The description of the Permission Set.
    • `managed_policies` - (Required) A list of managed policy names. The prefix `arn:aws:iam::aws:policy/`
                                      will be prepended to create the full ARN.
  EOT
  type = map(object({
    name             = optional(string)
    description      = optional(string)
    managed_policies = list(string)
  }))
}

variable "assignments" {
  description = <<EOT
    List of assignments between group, account and permission set. The key of each object is the group
    name that will be assigned the permissions. Ideally this group should be created via SCIM.
    
    • `account_ids`     - (Required) The AWS account IDs to apply the assignment.
    • `permission_sets` - (Required) The Permission Sets to be assigned to the group. These should
                                     be a subset of the Permission Sets created above.
  EOT
  type = map(object({
    account_ids     = list(string)
    permission_sets = list(string)
  }))
}