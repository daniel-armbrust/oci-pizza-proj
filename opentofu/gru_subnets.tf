#
# gru_subnets.tf
#

# PUBLIC SUBNET
resource "oci_core_subnet" "gru_subnpub" {
    provider = oci.gru

    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.gru_vcn.id
    dhcp_options_id = oci_core_dhcp_options.gru_dhcp-options.id
    route_table_id = oci_core_route_table.gru_rtb_subnpub.id
    security_list_ids = [oci_core_security_list.gru_secl-1_subnpub.id]

    display_name = "subnpub"
    dns_label = "subnpub"
    cidr_block = "172.16.30.0/24"
    prohibit_public_ip_on_vnic = false
}

# PRIVATE SUBNET
resource "oci_core_subnet" "gru_subnprv" {
    provider = oci.gru

    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.gru_vcn.id
    dhcp_options_id = oci_core_dhcp_options.gru_dhcp-options.id
    route_table_id = oci_core_route_table.gru_rtb_subnprv.id
    security_list_ids = [oci_core_security_list.gru_secl-1_subnprv.id]

    display_name = "subnprv"
    dns_label = "subnprv"
    cidr_block = "172.16.20.0/24"
    prohibit_public_ip_on_vnic = true
}