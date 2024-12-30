#
# scripts/chapter-5/fn-saopaulo.sh
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
region_code="gru"
env="$ENV"
compartment_ocid="$COMPARTMENT_OCID"
email_compartment_ocid="$compartment_ocid"
nosql_compartment_ocid="$compartment_ocid"

vcn_name="vcn-saopaulo"
prvsubnet_name="subnprv"

fn_appl_name="fn-appl-ocipizza"

fn_user_register_name="fn-user-register"
fn_passwd_recovery_name="fn-password-recovery"

nosql_user_table_name="user"
nosql_email_verification_table_name="email_verification"

vcn_ocid="$(get_vcn_ocid "$region" "$vcn_name" "$compartment_ocid")"
subnet_ocid="$(get_subnet_ocid "$region" "$prvsubnet_name" "$compartment_ocid" "$vcn_ocid")"

# Function Application
oci --region "$region" fn application create \
    --compartment-id "$compartment_ocid" \
    --display-name "$fn_appl_name" \
    --subnet-ids "[\"$subnet_ocid\"]" \
    --config "{
        \"OCI_REGION\": \"$region\",
        \"ENV\": \"$ENV\",    
        \"NOSQL_COMPARTMENT_OCID\": \"$nosql_compartment_ocid\",
        \"EMAIL_COMPARTMENT_OCID\": \"$email_compartment_ocid\",
        \"NOSQL_EMAIL_VERIFICATION_TABLE_NAME\": \"$nosql_email_verification_table_name\",
        \"NOSQL_USER_TABLE_NAME\": \"$nosql_user_table_name\"
    }" \
    --shape "GENERIC_X86" \
    --wait-for-state "ACTIVE"

fnappl_ocid="$(get_fnappl_ocid "$region" "$fn_appl_name" "$compartment_ocid")"
os_namespace="$(get_os_namespace)"
loggroup_ocid="$(get_loggroup_ocid "$region" "ocipizza-loggroup-saopaulo" "$compartment_ocid")"

# Function Service Log
oci --region "$region" logging log create \
    --log-group-id "$loggroup_ocid" \
    --display-name "log-service-fn" \
    --log-type "SERVICE" \
    --retention-duration 30 \
    --is-enabled "true" \
    --configuration "{
        \"archiving\": {
            \"isEnabled\": false
        },
        \"compartmentId\": \"$compartment_ocid\",
        \"source\": {
            \"category\": \"invoke\",            
            \"resource\": \"$fnappl_ocid\",
            \"service\": \"functions\",
            \"sourceType\": \"OCISERVICE\"
        }}" \
    --wait-for-state "SUCCEEDED"

# Function: fn-user-register:0.0.1
oci --region "$region" fn function create \
    --application-id "$fnappl_ocid" \
    --display-name "$fn_user_register_name" \
    --memory-in-mbs 128 \
    --timeout-in-seconds 300 \
    --image "$region_code.ocir.io/$os_namespace/fn-repo/$fn_user_register_name:0.0.1" \
    --wait-for-state "ACTIVE"

# Function: fn-user-register:0.0.1
oci --region "$region" fn function create \
    --application-id "$fnappl_ocid" \
    --display-name "$fn_passwd_recovery_name" \
    --memory-in-mbs 128 \
    --timeout-in-seconds 300 \
    --image "$region_code.ocir.io/$os_namespace/fn-repo/$fn_passwd_recovery_name:0.0.1" \
    --wait-for-state "ACTIVE"

exit 0    