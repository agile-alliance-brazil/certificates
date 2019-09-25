#!/usr/bin/env bash

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
for line in $(cat "${MY_DIR}/.env"); do export $line; done

bucket=${1}
shift

if [ -f ${bucket} ]; then
  echo "Usage: ${__FILE__} <bucket_name> [files]"
  echo "<bucket_name>:\tBucket that will receive the files"
  echo "[files]:\tAll the files to upload with their desired result path"
  exit 1
fi

dateValue=$(TZ=utc date -R)
ENDPOINT="nyc3.digitaloceanspaces.com"

for file in $*; do
  resource="/${bucket}/${file}"
  contentType=$(file --mime "${file}" | sed -e 's/^.*: //g')
  acl="public-read"
  stringToSign="PUT\n\n${contentType}\n${dateValue}\nx-amz-acl:${acl}\n${resource}"
  echo ${stringToSign}

  signature=$(echo -en ${stringToSign} | openssl sha1 -hmac ${DO_SPACES_SECRET_ACCESS_KEY} -binary | base64)
  curl -X PUT -T "${file}" \
    -H "Host: ${bucket}.${ENDPOINT}" \
    -H "Date: ${dateValue}" \
    -H "Content-Type: ${contentType}" \
    -H "Authorization: AWS ${DO_SPACES_ACCESS_KEY_ID}:${signature}" \
    -H "x-amz-acl: ${acl}" \
    "https://${bucket}.${ENDPOINT}/${file}" && echo "Uploaded ${file}"
done
