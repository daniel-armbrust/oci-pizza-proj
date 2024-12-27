#
# scripts/chapter-1/logging-vinhedo.sh
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

# Globals
region="sa-vinhedo-1"
compartment_ocid="$COMPARTMENT_OCID"

# Log Group
oci --region "$region" logging log-group create \
    --compartment-id "$compartment_ocid" \
    --display-name "ocipizza-loggroup-saopaulo" \
    --description "OCI Pizza - Log Group São Paulo" \
    --wait-for-state "SUCCEEDED"