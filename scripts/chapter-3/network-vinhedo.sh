#
# scripts/chapter-3/network-vinhedo.sh
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

#-------------------------------------------------#
# Brazil Southeast (Vinhedo) / sa-vinhedo-1 (VCP) #
#-------------------------------------------------#

# Source external files.
source functions.sh

# Globals
region="sa-vinhedo-1"

#-----#
# VCN #
#-----#

oci --region "$region" network vcn create \
    --compartment-id "$COMPARTMENT_OCID" \
    --cidr-blocks '["192.168.0.0/16"]' \
    --display-name "vcn-vinhedo" \
    --dns-label "vcnvinhedo" \
    --wait-for-state AVAILABLE

vcn_ocid="$(get_vcn_ocid "$region" "vcn-vinhedo")"

#------------------#
# INTERNET GATEWAY #
#------------------#

oci --region "$region" network internet-gateway create \
    --compartment-id "$COMPARTMENT_OCID" \
    --is-enabled "true" \
    --vcn-id "$vcn_ocid" \
    --display-name "igw" \
    --wait-for-state "AVAILABLE"

igw_ocid="$(get_igw_ocid "$region" "igw" "$vcn_ocid")"

#-------------#
# NAT GATEWAY #
#-------------#

oci --region "$region" network nat-gateway create \
    --compartment-id "$COMPARTMENT_OCID" \
    --vcn-id "$vcn_ocid" \
    --block-traffic "false" \
    --display-name "ngw" \
    --wait-for-state "AVAILABLE"

ngw_ocid="$(get_ngw_ocid "$region" "ngw" "$vcn_ocid")"

#-----------------#
# SERVICE GATEWAY #
#-----------------#

all_services_ocid="$(get_all_services_ocid "$region")"
all_services_name="$(get_all_services_name "$region")"
all_services_cidr_block="$(get_all_services_cidr_block "$region")"

oci --region "$region" network service-gateway create \
    --compartment-id "$COMPARTMENT_OCID" \
    --vcn-id "$vcn_ocid" \
    --services "[{\"serviceId\": \"$all_services_ocid\" , \"serviceName\": \"$all_services_name\"}]" \
    --display-name "sgw" \
    --wait-for-state "AVAILABLE"

sgw_ocid="$(get_sgw_ocid "$region" "$vcn_ocid")"

#--------------#
# DHCP OPTIONS #
#--------------#

oci --region "$region" network dhcp-options create \
    --compartment-id "$COMPARTMENT_OCID" \
    --options '[{"type": "DomainNameServer", "serverType": "VcnLocalPlusInternet"}]' \
    --vcn-id "$vcn_ocid" \
    --display-name "dhcp-options" \
    --domain-name-type "VCN_DOMAIN" \
    --wait-for-state "AVAILABLE"

dhcp_options_ocid="$(get_dhcpoptions_ocid "$region" "dhcp-options" "$vcn_ocid")"

#-------------#
# ROUTE TABLE #
#-------------#

# Public Subnet
oci --region "$region" network route-table create \
    --compartment-id "$COMPARTMENT_OCID" \
    --vcn-id "$vcn_ocid" \
    --display-name "rtb_subnpub" \
    --route-rules "[{\"destination\": \"0.0.0.0/0\", \"destinationType\": \"CIDR_BLOCK\", \"networkEntityId\": \"$igw_ocid\"}]" \
    --wait-for-state "AVAILABLE"

rtb_subnpub_ocid="$(get_rtb_ocid "$region" "rtb_subnpub" "$vcn_ocid")"

# Private Subnet
oci --region "$region" network route-table create \
    --compartment-id "$COMPARTMENT_OCID" \
    --vcn-id "$vcn_ocid" \
    --display-name "rtb_subnprv" \
    --route-rules "[
         {
            \"destination\": \"0.0.0.0/0\", 
            \"destinationType\": \"CIDR_BLOCK\", 
            \"networkEntityId\": \"$ngw_ocid\"
         },         
         {
            \"destination\": \"$all_services_cidr_block\", 
            \"destinationType\": \"SERVICE_CIDR_BLOCK\", 
            \"networkEntityId\": \"$sgw_ocid\"
         }
    ]" \
    --wait-for-state "AVAILABLE"

rtb_subnprv_ocid="$(get_rtb_ocid "$region" "rtb_subnprv" "$vcn_ocid")"

#---------------#
# SECURITY LIST #
#---------------#

# Public Subnet
oci --region "$region" network security-list create \
    --compartment-id "$COMPARTMENT_OCID" \
    --vcn-id "$vcn_ocid" \
    --display-name "seclist_subnpub" \
    --ingress-security-rules "[
        {
            \"source\": \"0.0.0.0/0\", 
            \"protocol\": \"6\", 
            \"isStateless\": false, 
            \"tcpOptions\": {
                \"destinationPortRange\": {
                        \"min\": 80, \"max\": 80
                }, 
                \"sourcePortRange\": {
                        \"min\": 1024, \"max\": 65535
                }
            }          
        },
        {
            \"source\": \"0.0.0.0/0\", 
            \"protocol\": \"6\", 
            \"isStateless\": false,
            \"tcpOptions\": {
                \"destinationPortRange\": {
                        \"min\": 443, \"max\": 443
                }, 
                \"sourcePortRange\": {
                        \"min\": 1024, \"max\": 65535
                }
            }              
        }
    ]" \
    --egress-security-rules "[
        {
           \"destination\": \"0.0.0.0/0\",
           \"protocol\": \"all\", 
           \"isStateless\": false
        }
    ]" \
    --wait-for-state "AVAILABLE"

seclist_subnpub_ocid="$(get_seclist_ocid "$region" "seclist_subnpub" "$vcn_ocid")"

# Private Subnet
oci --region "$region" network security-list create \
    --compartment-id "$COMPARTMENT_OCID" \
    --vcn-id "$vcn_ocid" \
    --display-name "seclist_subnprv" \
    --ingress-security-rules "[
        {
            \"source\": \"0.0.0.0/0\", 
            \"protocol\": \"all\", 
            \"isStateless\": false             
        }
    ]" \
    --egress-security-rules "[
        {
           \"destination\": \"0.0.0.0/0\",
           \"protocol\": \"all\", 
           \"isStateless\": false
        }
    ]" \
    --wait-for-state "AVAILABLE"

seclist_subnprv_ocid="$(get_seclist_ocid "$region" "seclist_subnprv" "$vcn_ocid")"

#--------#
# SUBNET #
#--------#

# Public Subnet
oci --region "$region" network subnet create \
    --compartment-id "$COMPARTMENT_OCID" \
    --cidr-block "192.168.30.0/24" \
    --vcn-id "$vcn_ocid" \
    --dhcp-options-id "$dhcp_options_ocid" \
    --route-table-id "$rtb_subnpub_ocid" \
    --security-list-ids "[\"$seclist_subnpub_ocid\"]" \
    --dns-label "subnpub" \
    --display-name "subnpub" \
    --prohibit-public-ip-on-vnic "false" \
    --prohibit-internet-ingress "false" \
    --wait-for-state "AVAILABLE"

# Private Subnet
oci --region "$region" network subnet create \
    --compartment-id "$COMPARTMENT_OCID" \
    --cidr-block "192.168.20.0/24" \
    --vcn-id "$vcn_ocid" \
    --dhcp-options-id "$dhcp_options_ocid" \
    --route-table-id "$rtb_subnprv_ocid" \
    --security-list-ids "[\"$seclist_subnprv_ocid\"]" \
    --dns-label "subnprv" \
    --display-name "subnprv" \
    --prohibit-public-ip-on-vnic "true" \
    --prohibit-internet-ingress "true" \
    --wait-for-state "AVAILABLE"

exit 0