#
# gru_objectstorage.tf
# 

resource "oci_objectstorage_bucket" "gru_bucket_pizza-img" {
    provider = oci.gru
    
    compartment_id = var.root_compartment
    name = "pizza-img"
    namespace = local.gru_objectstorage_ns
    access_type = "ObjectReadWithoutList"
    versioning = "Disabled"
}
