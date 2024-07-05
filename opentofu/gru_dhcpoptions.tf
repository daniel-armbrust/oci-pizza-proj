#
# gru_dhcpoptions.tf
#

# DHCP OPTIONS - VCN
resource "oci_core_dhcp_options" "gru_dhcp-options" {
    provider = oci.gru

    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.gru_vcn.id
    display_name = "dhcp-options"

    options {
        type = "DomainNameServer"
        server_type = "VcnLocalPlusInternet"
    }
}