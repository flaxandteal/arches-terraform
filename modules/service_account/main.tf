locals {
  iam_allowed_sas = {
    for key, sa in var.service_accounts : key => sa
    if lookup(sa, "allow_iam_roles", false) == true
  }

  iam_roles = distinct(flatten([
    for sa in local.iam_allowed_sas : sa.roles
  ]))

  workload_identity_bindings = flatten([
    for sa_key, sa in var.service_accounts :
    [
      for binding in lookup(sa, "workload_identity_bindings", []) : {
        gsa_key             = sa_key
        gsa_email           = "${sa.account_id}@${var.project_id}.iam.gserviceaccount.com"
        k8s_namespace       = binding.namespace
        k8s_service_account = binding.service_account
      }
    ]
  ])
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

resource "google_service_account_iam_member" "workload_identity_binding" {
  for_each = {
    for binding in local.workload_identity_bindings :
    "${binding.gsa_email}-${binding.k8s_namespace}-${binding.k8s_service_account}" => binding
  }

  service_account_id = "projects/${var.project_id}/serviceAccounts/${each.value.gsa_email}"
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[${each.value.k8s_namespace}/${each.value.k8s_service_account}]"
}
