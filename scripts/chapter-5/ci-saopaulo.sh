#
# scripts/chapter-5/ci-saopaulo.sh
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
compartment_ocid="$COMPARTMENT_OCID"
nosql_compartment_ocid="$compartment_ocid"
vcn_name="vcn-saopaulo"
prvsubnet_name="subnprv"

ad="$(get_ad "$region" "$compartment_ocid")"

vcn_ocid="$(get_vcn_ocid "$region" "$vcn_name" "$compartment_ocid")"
subnet_ocid="$(get_subnet_ocid "$region" "$prvsubnet_name" "$compartment_ocid" "$vcn_ocid")"

os_namespace="$(get_os_namespace)"
secret_key="$(< /dev/urandom tr -dc 'A-Za-z0-9' | head -c 60; echo)"
ocipizza_img_url="ocir.$region.oci.oraclecloud.com/$os_namespace/ocipizza:1.0"

# Container Instance PRIMARY
oci container-instances container-instance create \
    --display-name "ci-ocipizza-primary" \
    --availability-domain "$ad" \
    --compartment-id "$compartment_ocid" \
    --containers "[  
           {     
              \"displayName\": \"webapp-container-1\",
	          \"imageUrl\": \"$ocipizza_img_url\",
	          \"environmentVariables\": {
                  \"SECRET_KEY\": \"$secret_key\",
                  \"NOSQL_COMPARTMENT_OCID\": \"$nosql_compartment_ocid\"
              }
           }
        ]" \
    --container-restart-policy "ON_FAILURE" \
    --shape "CI.Standard.E4.Flex" \
    --shape-config "{\"memoryInGBs\": 4, \"ocpus\": 2}" \
    --vnics "[
           {
              \"displayName\": \"vnic-1\",
              \"isPublicIpAssigned\": false,
              \"subnetId\": \"$subnet_ocid\"
           }
        ]" \
    --wait-for-state "ACCEPTED"

# Container Instance BACKUP
oci container-instances container-instance create \
    --display-name "ci-ocipizza-backup" \
    --availability-domain "$ad" \
    --compartment-id "$compartment_ocid" \
    --containers "[  
           {     
              \"displayName\": \"webapp-container-1\",
	          \"imageUrl\": \"$ocipizza_img_url\",
	          \"environmentVariables\": {
                  \"SECRET_KEY\": \"$secret_key\",
                  \"NOSQL_COMPARTMENT_OCID\": \"$nosql_compartment_ocid\"
              }
           }
        ]" \
    --container-restart-policy "ON_FAILURE" \
    --shape "CI.Standard.E4.Flex" \
    --shape-config "{\"memoryInGBs\": 4, \"ocpus\": 2}" \
    --vnics "[
           {
              \"displayName\": \"vnic-1\",
              \"isPublicIpAssigned\": false,
              \"subnetId\": \"$subnet_ocid\"
           }
        ]" \
    --wait-for-state "ACCEPTED"

exit 0    