#
# gru_vcn.tf
#

resource "oci_core_vcn" "gru_vcn" {
    provider = oci.gru

    compartment_id = var.root_compartment
    cidr_blocks = ["172.16.0.0/16"]
    display_name = "vcn"
    dns_label = "gruvcn"
}