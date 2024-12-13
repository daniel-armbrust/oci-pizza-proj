#
# scripts/chapter-3/lb-saopaulo.sh
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

#-----------------------------------------------#
# Brazil East (Sao Paulo) / sa-saopaulo-1 (GRU) #
#-----------------------------------------------#

# Source external files.
source functions.sh

# Globals
region="sa-saopaulo-1"
lb_name="lb-saopaulo"
backendset_name="backendset-1"

## Load Balancer

vcn_ocid="$(get_vcn_ocid "$region" "vcn-saopaulo")"
subnpub_ocid="$(get_subnet_ocid "$region" "subnpub" "$vcn_ocid")"
reserved_ip_ocid="$(get_reserved_ip_ocid "$region" "pubip-lb-saopaulo")"

oci --region "$region" lb load-balancer create \
    --compartment-id "$COMPARTMENT_OCID" \
    --display-name "$lb_name" \
    --shape-name "flexible" \
    --shape-details "{\"minimumBandwidthInMbps\": 10, \"maximumBandwidthInMbps\": 10}" \
    --subnet-ids "[\"$subnpub_ocid\"]" \
    --is-private "false" \
    --reserved-ips "[{\"id\": \"$reserved_ip_ocid\"}]" \
    --wait-for-state "SUCCEEDED"

## Backend Set

lb_ocid="$(get_lb_ocid "$region" "$lb_name")"

oci --region "$region" lb backend-set create \
    --load-balancer-id "$lb_ocid" \
    --name "$backendset_name" \
    --policy "ROUND_ROBIN" \
    --health-checker-protocol "TCP" \
    --health-checker-port "5000" \
    --wait-for-state "SUCCEEDED"

## HTTP Listener

oci --region "$region" lb listener create \
    --default-backend-set-name "$backendset_name" \
    --load-balancer-id "$lb_ocid" \
    --name "listener-http" \
    --port 80 \
    --protocol "HTTP" \
    --wait-for-state "SUCCEEDED"

## HTTPS Listener

exit 0




