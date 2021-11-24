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

# This doesn't work on OSX because collate usage is outdated. Leaving in since using linux for real uploads.
urlencode() {
    # Usage: urlencode "string"
    old_lc_collate="${LC_COLLATE}"
    LC_COLLATE='C'
    
    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            ' ') printf "%%20" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done
    
    LC_COLLATE="${old_lc_collate}"
}

for file in $*; do
  filename=$(basename "${file}")
  dirname=$(dirname "${file}")
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
    "https://${bucket}.${ENDPOINT}/${dirname}/$(urlencode ${filename})" && echo "Uploaded ${file}"
done
