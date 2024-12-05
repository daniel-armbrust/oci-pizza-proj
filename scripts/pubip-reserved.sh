#
# scripts/pubip-reserved.sh
#
# OCI PUBLIC IP RESERVED
# ----------------------
#    https://docs.oracle.com/en-us/iaas/tools/oci-cli/3.50.2/oci_cli_docs/cmdref/network/public-ip/create.html
#
# How to execute (example):
# -------------------------
#
#    $ export COMPARTMENT_OCID="ocid1.compartment.oc1..aaaaaaaaaaaaaaaabbbbbbbbccc"
#    $ bash pubip-reserved.sh
#

oci network public-ip create \
    --compartment-id "$COMPARTMENT_OCID" \
    --lifetime "RESERVED" \
    --display-name "pubip-lb-saopaulo" \
    --wait-for-state "AVAILABLE"

oci network public-ip list \
    --compartment-id "$COMPARTMENT_OCID" \
    --lifetime "RESERVED" \
    --scope "REGION" \
    --query data[].\"ip-address\" \
    --all

exit 0