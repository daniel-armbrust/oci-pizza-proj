#
# datasource.tf
# 

#
# https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/data_source
#
data "external" "get_my_public_ip" {
    program = ["bash", "./scripts/get-my-publicip.sh"]
}

#
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/core_services
#
data "oci_core_services" "gru_all_oci_services" {
    provider = oci.gru

    filter {
       name   = "name"
       values = ["All .* Services In Oracle Services Network"]
       regex  = true
    }
}

#
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/identity_availability_domains
#
data "oci_identity_availability_domains" "gru_ads" {
    provider = oci.gru
    compartment_id = var.tenancy_id
}

#
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/identity_fault_domains
#
data "oci_identity_fault_domains" "gru_fds" {
    provider = oci.gru
    compartment_id = var.tenancy_id
    availability_domain = local.ads["gru_ad1_name"]
}

#
# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/objectstorage_namespace
#
data "oci_objectstorage_namespace" "gru_objectstorage_ns" {
    provider = oci.gru
    compartment_id = var.tenancy_id
}