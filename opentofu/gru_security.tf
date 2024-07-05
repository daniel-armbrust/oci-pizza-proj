#
# gru_security.tf
#

# PUBLIC SUBNET
resource "oci_core_security_list" "gru_secl-1_subnpub" {
    provider = oci.gru

    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.gru_vcn.id
    display_name = "secl-1_subnpub"

    egress_security_rules {
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
        protocol = "all"
        stateless = false
    } 

    ingress_security_rules {
        source = "${local.my_public_ip}"
        protocol = "all"
        source_type = "CIDR_BLOCK"
        stateless = false        
    }

    ingress_security_rules {
        source = "0.0.0.0/0"
        protocol = "1" # icmp
        source_type = "CIDR_BLOCK"
        stateless = false

        icmp_options {            
            type = "3"
            code = "4"
        }
    }
}

# PRIVATE SUBNET
resource "oci_core_security_list" "gru_secl-1_subnprv" {
    provider = oci.gru

    compartment_id = var.root_compartment
    vcn_id = oci_core_vcn.gru_vcn.id
    display_name = "secl-1_subnprv"

    egress_security_rules {
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
        protocol = "all"
        stateless = false
    } 

    ingress_security_rules {
        source = "0.0.0.0/0"
        source_type = "CIDR_BLOCK"
        protocol = "all"
        stateless = false  
    }   
}