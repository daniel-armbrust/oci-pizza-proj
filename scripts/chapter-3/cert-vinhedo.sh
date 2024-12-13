#
# scripts/chapter-3/cert-vinhedo.sh
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
cert_file="cert.pem"
cert_chain_file="chain.pem"
privkey_file="privkey.pem"

oci --region "$region" certs-mgmt certificate create-by-importing-config \
    --compartment-id "$COMPARTMENT_OCID" \
    --name "certificado-ocipizza" \
    --description "Certificado Digital da Aplicação OCI Pizza." \
    --certificate-pem "$(cat $cert_file)" \
    --cert-chain-pem "$(cat $cert_chain_file)" \
    --private-key-pem "$(cat $privkey_file)" \
    --wait-for-state "ACTIVE"

exit 0