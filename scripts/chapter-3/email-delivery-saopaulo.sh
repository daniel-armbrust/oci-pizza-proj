#
# scripts/chapter-3/email-delivery-saopaulo.sh
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
root_compartment_ocid="$ROOT_COMPARTMENT_OCID"
noreply_email_address="no-reply@ocipizza.com.br"

# Email Domain
oci --region "$region" email domain create \
    --compartment-id "$compartment_ocid" \
    --name "ocipizza.com.br" \
    --description "OCI Pizza - Email Delivery (Sao Paulo)" \
    --wait-for-state "SUCCEEDED"

# Approved Sender
oci --region "$region" email sender create \
    --compartment-id "$compartment_ocid" \
    --email-address "$noreply_email_address" \
    --wait-for-state "ACTIVE"

# DKIM
email_domain_ocid="$(get_email_domain_ocid "$region" "ocipizza.com.br" "$compartment_ocid")"
current_date="$(date +%Y%m%d)"
dkim_name="ocipizza-$region-$current_date"

oci --region "$region" email dkim create \
    --email-domain-id "$email_domain_ocid" \
    --name "$dkim_name" \
    --description "OCI Pizza - DKIM (Sao Paulo)" \
    --wait-for-state "SUCCEEDED"

dkim_ocid="$(get_email_dkim_ocid "$region" "$dkim_name" "$email_domain_ocid")"
dkim_cname="$(get_email_dkim_cname "$region" "$dkim_ocid")"
dkim_cname_record="$(get_email_dkim_cname_record "$region" "$dkim_ocid")"

# DNS
oci --region "$region" dns record domain patch \
    --compartment-id "$compartment_ocid" \
    --zone-name-or-id "ocipizza.com.br" \
    --domain "$dkim_cname" \
    --scope "GLOBAL" \
    --items "[{\"domain\": \"$dkim_cname\", \"rdata\": \"$dkim_cname_record\", \"rtype\": \"CNAME\", \"ttl\": 3600}]"

exit 0