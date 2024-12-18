#
# scripts/chapter-3/lb-vinhedo.sh
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
vcn_name="vcn-vinhedo"
pubsubnet_name="subnpub"
reserved_ip_name="pubip-lb-vinhedo"
lb_name="lb-vinhedo"
backendset_name="backendset-1"
cert_name="certificado-vinhedo"
http_ruleset_name="http_redirect_https"
compartment_ocid="$COMPARTMENT_OCID"

## Load Balancer

vcn_ocid="$(get_vcn_ocid "$region" "$vcn_name" "$compartment_ocid")"
subnpub_ocid="$(get_subnet_ocid "$region" "$pubsubnet_name" "$vcn_ocid" "$compartment_ocid")"
reserved_ip_ocid="$(get_reserved_ip_ocid "$region" "$reserved_ip_name" "$compartment_ocid")"

oci --region "$region" lb load-balancer create \
    --compartment-id "$compartment_ocid" \
    --display-name "$lb_name" \
    --shape-name "flexible" \
    --shape-details "{\"minimumBandwidthInMbps\": 10, \"maximumBandwidthInMbps\": 10}" \
    --subnet-ids "[\"$subnpub_ocid\"]" \
    --is-private "false" \
    --reserved-ips "[{\"id\": \"$reserved_ip_ocid\"}]" \
    --wait-for-state "SUCCEEDED"

## Backend Set

lb_ocid="$(get_lb_ocid "$region" "$lb_name" "$compartment_ocid")"

oci --region "$region" lb backend-set create \
    --load-balancer-id "$lb_ocid" \
    --name "$backendset_name" \
    --policy "ROUND_ROBIN" \
    --health-checker-protocol "TCP" \
    --health-checker-port "5000" \
    --wait-for-state "SUCCEEDED"

## Rule Set (HTTP to HTTPS Redirect)

oci --region "$region" lb rule-set create \
    --load-balancer-id "$lb_ocid" \
    --name "$http_ruleset_name" \
    --items '[
        {
           "action": "REDIRECT", 
           "conditions": [
               {
                  "attributeName": "PATH", 
                  "attributeValue": "/", 
                  "operator": "FORCE_LONGEST_PREFIX_MATCH"
                }
            ], 
            "redirectUri": {
                "host": "{host}", 
                "path": "{path}", 
                "port": 443, 
                "protocol": "HTTPS", 
                "query": "{query}"
            }, 
            "responseCode": 301
        }
    ]' \
    --wait-for-state "SUCCEEDED"

## HTTP Listener

oci --region "$region" lb listener create \
    --default-backend-set-name "$backendset_name" \
    --load-balancer-id "$lb_ocid" \
    --name "listener-http" \
    --rule-set-names "[\"$http_ruleset_name\"]" \
    --port 80 \
    --protocol "HTTP" \
    --wait-for-state "SUCCEEDED"

## HTTPS Listener

cert_ocid="$(get_cert_ocid "$region" "$cert_name" "$compartment_ocid")"

oci --region "$region" lb listener create \
    --default-backend-set-name "$backendset_name" \
    --load-balancer-id "$lb_ocid" \
    --name "listener-https" \
    --port 443 \
    --protocol "HTTP" \
    --ssl-certificate-ids "[\"$cert_ocid\"]" \
    --wait-for-state "SUCCEEDED"

exit 0