#
# scripts/chapter-5/functions.sh
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

function get_ad() {
    local region="$1"
    local compartment_ocid="$2"

    oci --region "$region" iam availability-domain list \        
        --compartment-id "$compartment_ocid" \
        --all \
        --query 'data[0].name' | tr -d '"'
}

function get_vcn_ocid() {  
    local region="$1"
    local name="$2"
    local compartment_ocid="$3"

    oci --region "$region" network vcn list \
        --compartment-id "$compartment_ocid" \
        --all \
        --display-name "$name" \
        --query 'data[].id' | tr -d '[]" \n'
}

function get_subnet_ocid() {
    local region="$1"
    local name="$2"
    local compartment_ocid="$3"
    local vcn_ocid="$4"

    oci --region "$region" network subnet list \
        --compartment-id "$compartment_ocid" \
        --display-name "$name" \
        --all \
        --lifecycle-state "AVAILABLE" \
        --vcn-id "$vcn_ocid" \
        --query 'data[].id' | tr -d '[]" \n'
}

function get_fnappl_ocid() {
    local region="$1"
    local name="$2"
    local compartment_ocid="$3"

    oci --region "$region" fn application list \
        --compartment-id "$compartment_ocid" \
        --all \
        --display-name "$name" \
        --lifecycle-state "ACTIVE" \
        --query 'data[].id' | tr -d '[]" \n'
}

function get_os_namespace() {
    oci os ns get | awk '{print $2}' | tr -d '"\n '
}

function get_loggroup_ocid() {
    local region="$1"
    local name="$2"
    local compartment_ocid="$3"

    oci --region "$region" logging log-group list \
        --compartment-id "$compartment_ocid" \
        --all \
        --display-name "$name" \
        --query 'data[].id' | tr -d '[]" \n'
}