#!/bin/bash

# Parse command-line arguments
FILE_PATH=$1
BUCKET_PATH=$2

message(){
  echo -e "****Cloud Uploader Instructions*****"
  echo -e
  echo -e "usage clouduploader \e[34m/path/to/file\e[0m [bucket-path]"
}



# Validate that file path is provided
if [ -z "$FILE_PATH" ]; then
  message
  exit 1
fi



if [ -f "$FILE_PATH" ]; then
#for a single file upload
  FILES_TO_UPLOAD=("$FILE_PATH")
elif [ -d "$FILE_PATH" ]; then
#for directory upload
  FILES_TO_UPLOAD=($(find "$FILE_PATH" -type f))
else
  echo -e "\e[31mError file or directory doesn't exist\e[0m"
  exit 1
fi


# Upload file or directory to cloud storage
echo "Uploading $FILE_PATH to $BUCKET_PATH ..."

for file in "${FILES_TO_UPLOAD[@]}";do
  if [ -f "$file" ];then
    echo "Uploading $file to $BUCKET_PATH...."
    aws s3 cp "/$file" $BUCKET_PATH --acl public-read

# check if upload was successful
    if [ $? -eq 0 ];then
      echo "✅ Success: File '$file' has been uploaded to '$BUCKET_PATH'."
    else
      echo "❌ Error: Failed to upload '$file' to S3."
        exit 1
    fi
  fi
done



# Generate and display the URL
for file in "${FILES_TO_UPLOAD[@]}"; do
  S3_URL="https://s3.amazonaws.com/$BUCKET_PATH/$(basename "$file")"
  echo "🌐 Access your file at: $S3_URL"
done