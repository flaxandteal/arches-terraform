locals {
  iam_allowed_sas = {
    for key, sa in var.service_accounts : key => sa
    if lookup(sa, "allow_iam_roles", false) == true
  }

  iam_roles = distinct(flatten([
    for sa in local.iam_allowed_sas : sa.roles
  ]))
}

resource "google_service_account" "service_account" {
  for_each     = var.service_accounts
  project      = var.project_id
  account_id   = each.value.account_id
  display_name = each.value.display_name
  description  = each.value.description

}

resource "google_project_iam_binding" "service_account_roles" {
  for_each = toset(local.iam_roles)
  project  = var.project_id
  role     = "roles/${each.key}"

  members = [
    for sa_key, sa in local.iam_allowed_sas :
    "serviceAccount:${google_service_account.service_account[sa_key].email}"
    if contains(sa.roles, each.key)
  ]
}