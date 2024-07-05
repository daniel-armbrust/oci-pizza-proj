#
# gru_routetable.tf
#

# PUBLIC SUBNET
resource "oci_core_route_table" "gru_rtb_subnpub" {
    provider = oci.gru

    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.gru_vcn.id
    display_name = "rtb_subnpub"

    # INTERNET GATEWAY
    route_rules {
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
        network_entity_id = oci_core_internet_gateway.gru_igw.id
        description = "INTERNET GATEWAY"
    }
}

# PRIVATE SUBNET
resource "oci_core_route_table" "gru_rtb_subnprv" {
    provider = oci.gru

    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.gru_vcn.id
    display_name = "rtb_subnprv"

    # SERVICE GATEWAY
    route_rules {
        destination = "all-gru-services-in-oracle-services-network"
        destination_type = "SERVICE_CIDR_BLOCK"
        network_entity_id = oci_core_service_gateway.gru_sgw.id
        description = "SERVICE GATEWAY"
    }
}