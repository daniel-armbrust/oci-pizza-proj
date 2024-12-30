#
# scripts/chapter-4/nosql.sh
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

# Globals
main_region="sa-saopaulo-1"
backup_region="sa-vinhedo-1"
compartment_ocid="$COMPARTMENT_OCID"

# Pizza Table
oci --region "$main_region" nosql table create \
    --compartment-id "$compartment_ocid" \
    --name "pizza" \
    --table-limits "{\"capacityMode\": \"PROVISIONED\", \"maxReadUnits\": 5, \"maxWriteUnits\": 5, \"maxStorageInGBs\": 10}" \
    --wait-for-state "SUCCEEDED" \
    --ddl-statement "
        CREATE TABLE IF NOT EXISTS pizza (
            id INTEGER,
            name STRING,
            description STRING,
            image STRING,
            price NUMBER,
            json_replica JSON,
         PRIMARY KEY(id))"

# Pizza Table Replica
oci --region "$main_region" nosql table update \
    --compartment-id "$compartment_ocid" \
    --table-name-or-id "pizza" \
    --ddl-statement "ALTER TABLE pizza FREEZE SCHEMA" \
    --force \
    --wait-for-state "SUCCEEDED"

oci --region "$main_region" nosql table create-replica \
    --compartment-id "$compartment_ocid" \
    --replica-region "$backup_region" \
    --table-name-or-id "pizza" \
    --max-read-units 5 \
    --max-write-units 5 \
    --wait-for-state "SUCCEEDED"

# User Table
oci --region "$main_region" nosql table create \
    --compartment-id "$compartment_ocid" \
    --name "user" \
    --table-limits "{\"capacityMode\": \"PROVISIONED\", \"maxReadUnits\": 5, \"maxWriteUnits\": 5, \"maxStorageInGBs\": 10}" \
    --wait-for-state "SUCCEEDED" \
    --ddl-statement "
         CREATE TABLE IF NOT EXISTS user (
            id INTEGER,
            name STRING,
            email STRING,
            password STRING,
            telephone STRING,
            verified BOOLEAN DEFAULT FALSE,
            json_replica JSON,           
         PRIMARY KEY(id))"

# User Table Replica
oci --region "$main_region" nosql table update \
    --compartment-id "$compartment_ocid" \
    --table-name-or-id "user" \
    --ddl-statement "ALTER TABLE user FREEZE SCHEMA" \
    --force \
    --wait-for-state "SUCCEEDED"

oci --region "$main_region" nosql table create-replica \
    --compartment-id "$compartment_ocid" \
    --replica-region "$backup_region" \
    --table-name-or-id "user" \
    --max-read-units 5 \
    --max-write-units 5 \
    --wait-for-state "SUCCEEDED"

# User Order Table
oci --region "$main_region" nosql table create \
    --compartment-id "$compartment_ocid" \
    --name "user.order" \
    --wait-for-state "SUCCEEDED" \
    --ddl-statement "
         CREATE TABLE IF NOT EXISTS user.order ( 
            order_id INTEGER,             
            address JSON,
            pizza JSON,  
            total NUMBER,
            order_datetime INTEGER,
            status ENUM(PREPARING,OUT_FOR_DELIVERY,DELIVERED,CANCELED) DEFAULT PREPARING,             
         PRIMARY KEY (order_id))"

# User Order Table Replica
oci --region "$main_region" nosql table update \
    --compartment-id "$compartment_ocid" \
    --table-name-or-id "user.order" \
    --ddl-statement "ALTER TABLE user.order FREEZE SCHEMA" \
    --force \
    --wait-for-state "SUCCEEDED"

oci --region "$main_region" nosql table create-replica \
    --compartment-id "$compartment_ocid" \
    --replica-region "$backup_region" \
    --table-name-or-id "user.order" \
    --max-read-units 5 \
    --max-write-units 5 \
    --wait-for-state "SUCCEEDED"

# Email Verification Table
oci --region "$main_region" nosql table create \
    --compartment-id "$compartment_ocid" \
    --name "email_verification" \
    --table-limits "{\"capacityMode\": \"PROVISIONED\", \"maxReadUnits\": 5, \"maxWriteUnits\": 5, \"maxStorageInGBs\": 2}" \
    --wait-for-state "SUCCEEDED" \
    --ddl-statement "
         CREATE TABLE IF NOT EXISTS email_verification ( 
            email STRING,
            token STRING,   
            password_recovery BOOLEAN DEFAULT FALSE,                      
            expiration_ts INTEGER,
         PRIMARY KEY (email)) USING TTL 1 DAYS"

oci --region "$backup_region" nosql table create \
    --compartment-id "$compartment_ocid" \
    --name "email_verification" \
    --table-limits "{\"capacityMode\": \"PROVISIONED\", \"maxReadUnits\": 5, \"maxWriteUnits\": 5, \"maxStorageInGBs\": 2}" \
    --wait-for-state "SUCCEEDED" \
    --ddl-statement "
         CREATE TABLE IF NOT EXISTS email_verification ( 
            email STRING,
            token STRING,                         
            expiration_ts INTEGER,
         PRIMARY KEY (email)) USING TTL 1 DAYS"
         
exit 0