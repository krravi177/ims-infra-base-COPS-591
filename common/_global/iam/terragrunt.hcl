include "root" {
  path   = find_in_parent_folders()
  expose = true
}

inputs = {
  region               = include.root.locals.region
  account_id           = include.root.locals.account_id
  execution_account_id = include.root.locals.execution_account_id
}
