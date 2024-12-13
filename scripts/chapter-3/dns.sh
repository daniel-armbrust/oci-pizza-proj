#
# scripts/chapter-3/dns.sh
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

## Create DNS Zone "ocipizza.com.br".

echo -e "[INFO] Creating OCI DNS Zone \"ocipizza.com.br\" ...\n"

oci dns zone create --compartment-id "$COMPARTMENT_OCID" \
    --name "ocipizza.com.br" \
    --zone-type "PRIMARY" \
    --scope "GLOBAL" \
    --wait-for-state "ACTIVE"

## Get the nameservers from "ocipizza.com.br" domain.

echo -e "[INFO] Nameservers from \"ocipizza.com.br\" ...\n"

oci dns zone get --compartment-id "$COMPARTMENT_OCID" \
    --zone-name-or-id "ocipizza.com.br" \
    --scope "GLOBAL" | grep "hostname" | tr -d '"' | awk '{print $2}'

exit 0