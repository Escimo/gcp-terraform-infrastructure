resource "google_storage_bucket" "tf_bucket" {
  name                        = "my-bucket-for-tfstate"  # Replace with your GCS bucket name
  location                    = "US"                     # Location of the bucket
  force_destroy               = true                     # Delete the bucket even if it contains objects
  uniform_bucket_level_access = true                     # Apply uniform access policies
  
  # Optional: Add lifecycle rules or other configurations if needed
}
