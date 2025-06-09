# NOTE! GCP does not allow the deletion of a key ring AT ALL
# and the key ring name must be unique within the project and location.
# So, if you want to delete a key ring, you must delete the project.
# Hence, we have added checking in the ci to import the keys if they exist

resource "google_kms_key_ring" "key_ring" {
  name     = var.name
  project  = var.project_id
  location = var.location
}

resource "google_kms_crypto_key" "crypto_key" {
  for_each        = var.crypto_keys
  name            = each.value.name
  key_ring        = google_kms_key_ring.key_ring.id
  purpose         = "ENCRYPT_DECRYPT"
  rotation_period = "100000s"

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_kms_crypto_key_iam_member" "crypto_key_iam" {
  for_each = {
    for key, value in var.crypto_keys : key => value
    if value.service_account_key != ""
  }
  crypto_key_id = google_kms_crypto_key.crypto_key[each.key].id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${var.service_accounts[each.value.service_account_key].account_id}@${var.project_id}.iam.gserviceaccount.com"
}