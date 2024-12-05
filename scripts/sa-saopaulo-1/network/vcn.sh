#
# scripts/sa-saopaulo-1/network/vcn.sh
#
# VCN (Virtual Cloud Network)
# ---------------------------
#   
# How to execute (example):
# -------------------------
#
#    $ export COMPARTMENT_OCID="ocid1.compartment.oc1..aaaaaaaaaaaaaaaabbbbbbbbccc"
#    $ bash vcn.sh
#

# Create
oci --region sa-saopaulo-1 network vcn create \
    --compartment-id "$COMPARTMENT_OCID" \
    --cidr-blocks '["172.16.0.0/16"]' \
    --display-name "vcn-saopaulo" \
    --dns-label "vcnsaopaulo" \
    --wait-for-state AVAILABLE

# Get OCID
oci --region sa-saopaulo-1 network vcn list \
    --compartment-id "$COMPARTMENT_OCID" \
    --all \
    --display-name "vcn-saopaulo" \
    --query 'data[].id'

exit 0