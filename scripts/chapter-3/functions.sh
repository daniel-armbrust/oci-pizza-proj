#
# scripts//chapter-3/functions.sh
#
# Copyright (C) 2005-2024 by Daniel Armbrust <darmbrust@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#

function get_vcn_ocid() {  
    local region="$1"
    local name="$2"

    oci --region "$region" network vcn list \
        --compartment-id "$COMPARTMENT_OCID" \
        --all \
        --display-name "$name" \
        --query 'data[].id' | tr -d '[]" \n'
}

function get_dhcpoptions_ocid() {  
    local region="$1"
    local name="$2"
    local vcn_ocid="$3"

    oci --region "$region" network dhcp-options list \
        --compartment-id "$COMPARTMENT_OCID" \
        --all \
        --display-name "$name" \
        --lifecycle-state "AVAILABLE" \
        --vcn-id "$vcn_ocid" \
        --query 'data[].id' | tr -d '[]" \n'
}

function get_all_services_ocid() {
    local region="$1"

    oci --region "$region" network service list \
        --all \
        --query "data[?contains(\"cidr-block\", 'all')].id" | tr -d '[]" \n'
}

function get_all_services_name() {
    local region="$1"

    oci --region "$region" network service list \
        --all \
        --query "data[?contains(\"cidr-block\", 'all')].name" | tr -d '[]"\n' | cut -f3- -d ' '
}

function get_all_services_cidr_block() {
    local region="$1"

    oci --region "$region" network service list \
        --all \
        --query "data[?contains(\"cidr-block\", 'all')].\"cidr-block\"" | tr -d '[]"\n' | cut -f3- -d ' '
}

function get_sgw_ocid() {
    local region="$1"
    local vcn_ocid="$2"

    oci --region "$region" network service-gateway list \
        --compartment-id "$COMPARTMENT_OCID" \
        --all \
        --vcn-id "$vcn_ocid" \
        --lifecycle-state "AVAILABLE" \
        --query 'data[].id' | tr -d '[]" \n'
}

function get_igw_ocid() {
    local region="$1"
    local name="$2"
    local vcn_ocid="$3"

    oci --region "$region" network internet-gateway list \
        --compartment-id "$COMPARTMENT_OCID" \
        --all \
        --display-name "$name" \
        --vcn-id "$vcn_ocid" \
        --lifecycle-state "AVAILABLE" \
        --query 'data[].id' | tr -d '[]" \n'
}

function get_ngw_ocid() {
    local region="$1"
    local name="$2"
    local vcn_ocid="$3"

    oci --region "$region" network nat-gateway list \
        --compartment-id "$COMPARTMENT_OCID" \
        --all \
        --display-name "$name" \
        --vcn-id "$vcn_ocid" \
        --lifecycle-state "AVAILABLE" \
        --query 'data[].id' | tr -d '[]" \n'
}

function get_seclist_ocid() {
    local region="$1"
    local name="$2"
    local vcn_ocid="$3"    

    oci --region "$region" network security-list list \
        --compartment-id "$COMPARTMENT_OCID" \
        --all \
        --display-name "$name" \
        --vcn-id "$vcn_ocid" \
        --lifecycle-state "AVAILABLE" \
        --query 'data[].id' | tr -d '[]" \n'
}

function get_rtb_ocid() {
    local region="$1"
    local name="$2"
    local vcn_ocid="$3"    

    oci --region "$region" network route-table list \
        --compartment-id "$COMPARTMENT_OCID" \
        --all \
        --display-name "$name" \
        --vcn-id "$vcn_ocid" \
        --lifecycle-state "AVAILABLE" \
        --query 'data[].id' | tr -d '[]" \n'
}

function get_reserved_ip_ocid() {
    local region="$1"
    local name="$2"

    oci --region "$region" network public-ip list \
        --compartment-id "$COMPARTMENT_OCID" \
        --lifetime "RESERVED" \
        --scope "REGION" \
        --all \
        --query "data[?name==\"$name\"].id" | tr -d '"[]\n '
}

function get_subnet_ocid() {
    local region="$1"
    local name="$2"
    local vcn_ocid="$3"

    oci --region "$region" network subnet list \
        --compartment-id "$COMPARTMENT_OCID" \
        --all \
        --display-name "$name" \
        --lifecycle-state "AVAILABLE" \
        --vcn-id "$vcn_ocid" \
        --query 'data[].id' | tr -d '"[]\n '
}

function get_lb_ocid() {
    local region="$1"
    local name="$2"
    
    oci --region "$region" lb load-balancer list \
        --compartment-id "$COMPARTMENT_OCID" \
        --all \
        --display-name "$name" \
        --lifecycle-state "ACTIVE" \
        --query 'data[].id' | tr -d '"[]\n '
}

function get_cert_ocid() {
    local region="$1"
    local name="$2"
    
    oci --region "$region" certs-mgmt certificate list \
        --compartment-id "$COMPARTMENT_OCID" \
        --all \
        --name "$name" \
        --query 'data.items[].id' | tr -d '"[]\n '    
}