#
# scripts/dns.sh
#
# OCI DNS CLI Documentation:
# --------------------------
#    https://docs.oracle.com/en-us/iaas/tools/oci-cli/3.50.2/oci_cli_docs/cmdref/dns/zone/create.html
#
# How to execute (example):
# -------------------------
#
#    $ export COMPARTMENT_OCID="ocid1.compartment.oc1..aaaaaaaaaaaaaaaabbbbbbbbccc"
#    $ bash dns.sh
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