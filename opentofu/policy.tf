#
# policy.tf
#

resource "oci_identity_dynamic_group" "dyngrp_ocipizza" {
    compartment_id = var.tenancy_id

    name = "ocipizza-dyngrp"
    description = "Grupo dinâmico que concede acesso aos Recursos da aplicação OCI Pizza."

    matching_rule = "All {resource.compartment.id = '${var.root_compartment}', instance.compartment.id = '${var.root_compartment}'}"
}

resource "oci_identity_policy" "policy" {    
    compartment_id = var.tenancy_id

    name = "ocipizza-policies"
    description = "IAM Policies da aplicação OCI Pizza."

    statements = [
       "Allow service objectstorage-sa-saopaulo-1 to manage object-family in compartment id ${var.root_compartment}", 
       "Allow dynamic-group ${oci_identity_dynamic_group.dyngrp_ocipizza.name} to manage objects in compartment id ${var.root_compartment}",       
       "Allow dynamic-group ${oci_identity_dynamic_group.dyngrp_ocipizza.name} to use log-content in compartment id ${var.root_compartment}",
       "Allow dynamic-group ${oci_identity_dynamic_group.dyngrp_ocipizza.name} to read repos in compartment id ${var.root_compartment}",
    ]
}