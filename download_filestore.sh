#!/bin/bash


### db_name parameter that must be given to the script to download the filestore backup ###
db_name="$1"
if [ -z "$db_name" ]; then
    echo "ERROR: No db_name given"
    exit 1
fi


### deployment_name parameter that must be given to the script to download the filestore backup ###
deployment_name="$2"
if [ -z "$deployment_name" ]; then
    echo "ERROR: No deployment_name given"
    exit 1
fi

### Placing us on the odoo data diretory and creating filestore directory ###
cd /var/lib/odoo/data
mkdir -p /var/lib/odoo/data/filestore
cd filestore/

s3_url="s3://filestores-odoo-prod/${deployment_name}/${db_name}/${db_name}_filestore.tar.gz"

### Generating the filestore backup file for the given database name ###
echo -n "Downloading filestore ... "
aws s3 cp $s3_url .
error=$?
if [ $error -eq 0 ]; then echo "Successfully downloaded filestore"; else echo "ERROR: $error"; fi


### uploading the compressed filestore backup files  to the filestores-odoo-prod s3 bucket in AWS ###
tar xf "${db_name}_filestore.tar.gz"
error=$?
if [ $error -eq 0 ]; then echo "Successfully uncompressed filestore backup"; else echo "ERROR: $error"; fi

### uploading the compressed filestore backup files  to the filestores-odoo-prod s3 bucket in AWS ###
rm "${db_name}_filestore.tar.gz"
error=$?
if [ $error -eq 0 ]; then echo "Successfully clean up"; else echo "ERROR: $error"; fi

