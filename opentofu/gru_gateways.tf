#
# gru_gateways.tf
#

# INTERNET GATEWAY
resource "oci_core_internet_gateway" "gru_igw" {
    provider = oci.gru

    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.gru_vcn.id
    display_name = "igw"
    enabled = true
}

# SERVICE GATEWAY
resource "oci_core_service_gateway" "gru_sgw" {
    provider = oci.gru

    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.gru_vcn.id
    display_name = "sgw"

    services {
        service_id = local.gru_all_oci_services
    }
}