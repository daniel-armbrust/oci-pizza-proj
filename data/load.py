#
# load.py - Load Pizzaria data into Oracle Cloud (OCI)
#

import sys
import os
import json

import oci

# Globals
OCI_CONFIG_FILE = os.environ.get('OCI_CONFIG_FILE') or '~/.oci/config'
NOSQL_COMPARTMENT_OCID = os.environ.get('NOSQL_COMPARTMENT_OCID')
PIZZA_IMG_BUCKET = os.environ.get('PIZZA_IMG_BUCKET') or 'pizza-img' 
NOSQL_PIZZA_TABLE_NAME = os.environ.get('NOSQL_PIZZA_TABLE_NAME') or 'pizza'


def init_oci_sdk():    
    config = oci.config.from_file(file_location=OCI_CONFIG_FILE)    
    oci.config.validate_config(config)
    
    return config


def load_img(oci_config=None):
    os_client = oci.object_storage.ObjectStorageClient(
        config=oci_config
    )

    img_url_list = []

    ns = os_client.get_namespace().data
    dir = 'img/'

    for img in os.listdir(dir):
        img_path = os.path.join(dir, img)                
        img_data = open(img_path, mode='rb').read()

        img_url = f'https://objectstorage.sa-saopaulo-1.oraclecloud.com/n/{ns}/b/{PIZZA_IMG_BUCKET}/o/{img}'
        img_url_list.append(img_url)

        resp = os_client.put_object(
            namespace_name=ns,
            bucket_name=PIZZA_IMG_BUCKET,
            object_name=img,
            content_type='image/jpeg',
            put_object_body=img_data
        )

        if resp.status == 200:
            print(f'[INFO] Upload IMAGE "{img}" ... OK!')
        else:
            print(f'[ERROR] Error to upload the IMAGE "{img}" to Object Storage.')
            sys.exit(1)
    
    return img_url_list

                
def load_pizza(oci_config=None, img_url_list=[]):    
    nosql = oci.nosql.NosqlClient(config=oci_config)

    f = open('pizza.data')

    for line in f.readlines():
        line = line.rstrip('\n')

        data = json.loads(line)    
        data['image'] = img_url_list.pop(0)
        
        update_row_details = oci.nosql.models.UpdateRowDetails(
            compartment_id=NOSQL_COMPARTMENT_OCID,
            value=data,
            option='IF_ABSENT'
        )        

        resp = nosql.update_row(
            table_name_or_id=NOSQL_PIZZA_TABLE_NAME,
            update_row_details=update_row_details
        )

        if resp.status == 200:
            print('[INFO] Insert NoSQL ROW ... OK!')
        else:
            print('[ERROR] Error to insert NoSQL ROW.')
            sys.exit(1)
        
    f.close()


def main():
    oci_config = init_oci_sdk()

    img_url_list = load_img(oci_config)

    load_pizza(oci_config, img_url_list)

    sys.exit(0)
    

if __name__ == '__main__':
    main()
else:
    sys.exit(1)