#
# scripts/ci-saopaulo.sh
#
# OCI CONTAINER INSTANCE CLI Documentation:
# -----------------------------------------
#    hhttps://docs.oracle.com/en-us/iaas/tools/oci-cli/3.50.2/oci_cli_docs/cmdref/container-instances/container-instance/create.html
#
# How to execute (example):
# -------------------------
#    
#    $ bash ci-saopaulo.sh
#

function return_ad() {
    oci iam availability-domain list \
        --region sa-saopaulo-1 \
        --compartment-id "$COMPARTMENT_OCID" \
        --all \
        --query "data[0].name" | tr -d '"'
}

COMPARTMENT_OCID=""
NOSQL_COMPARTMENT_OCID="$COMPARTMENT_OCID"
SUBNET_OCID=""

SECRET_KEY="$(< /dev/urandom tr -dc 'A-Za-z0-9' | head -c 60; echo)"
AVAILABILITY_DOMAIN="$(return_ad)"

# Container Instance PRIMARY
oci container-instances container-instance create \
    --display-name "ci-ocipizza-primary" \
    --availability-domain "$AVAILABILITY_DOMAIN" \
    --compartment-id "$COMPARTMENT_OCID" \
    --containers "[  
           {     
              \"displayName\": \"webapp-container-1\",
	          \"imageUrl\": \"ocir.sa-saopaulo-1.oci.oraclecloud.com/grxmw2a9myyj/ocipizza:1.0\",
	          \"environmentVariables\": {
                  \"SECRET_KEY\": \"$SECRET_KEY\",
                  \"NOSQL_COMPARTMENT_OCID\": \"$NOSQL_COMPARTMENT_OCID\"
              }
           }
        ]" \
    --container-restart-policy "ON_FAILURE" \
    --shape "CI.Standard.E4.Flex" \
    --shape-config "{\"memoryInGBs\": 4, \"ocpus\": 2}" \
    --vnics "[
           {
              \"displayName\": \"vnic-1\",
              \"isPublicIpAssigned\": false,
              \"subnetId\": \"$SUBNET_OCID\"
           }
        ]" \
    --wait-for-state "ACCEPTED"

# Container Instance BACKUP
oci container-instances container-instance create \
    --display-name "ci-ocipizza-backup" \
    --availability-domain "$AVAILABILITY_DOMAIN" \
    --compartment-id "$COMPARTMENT_OCID" \
    --containers "[  
           {     
              \"displayName\": \"webapp-container-1\",
	          \"imageUrl\": \"ocir.sa-saopaulo-1.oci.oraclecloud.com/grxmw2a9myyj/ocipizza:1.0\",
	          \"environmentVariables\": {
                  \"SECRET_KEY\": \"$SECRET_KEY\",
                  \"NOSQL_COMPARTMENT_OCID\": \"$NOSQL_COMPARTMENT_OCID\"
              }
           }
        ]" \
    --container-restart-policy "ON_FAILURE" \
    --shape "CI.Standard.E4.Flex" \
    --shape-config "{\"memoryInGBs\": 4, \"ocpus\": 2}" \
    --vnics "[
           {
              \"displayName\": \"vnic-1\",
              \"isPublicIpAssigned\": false,
              \"subnetId\": \"$SUBNET_OCID\"
           }
        ]" \
    --wait-for-state "ACCEPTED"

exit 0    