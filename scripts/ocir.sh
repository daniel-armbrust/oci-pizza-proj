#
# scripts/ocir.sh
#
# OCI CONTAINER REGISTRY CLI Documentation:
# -----------------------------------------
#    https://docs.oracle.com/en-us/iaas/tools/oci-cli/3.50.2/oci_cli_docs/cmdref/artifacts/container/repository/create.html
#
# How to execute (example):
# -------------------------
#
#    $ export COMPARTMENT_OCID="ocid1.compartment.oc1..aaaaaaaaaaaaaaaabbbbbbbbccc"
#    $ bash ocir.sh
#

oci artifacts container repository create \
    --compartment-id "$COMPARTMENT_OCID" \
    --display-name "ocipizza" \
    --wait-for-state "AVAILABLE"

exit 0