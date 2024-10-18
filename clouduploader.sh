#!/bin/bash

# Parse command-line arguments
FILE_PATH=$1
BUCKET_PATH=$2

# Validate that file path is provided
if [ -z "$FILE_PATH" ]; then
  echo "Error: No file path provided."
  echo "Usage: clouduploader /path/to/file [bucket-path]"
  exit 1
fi

# Check if file exists
if [ ! -f "$FILE_PATH" ]; then
  echo "Error: File does not exist."
  exit 1
fi

# Upload file to cloud storage
echo "Uploading $FILE_PATH to $BUCKET_PATH ..."
aws s3 cp "/$FILE_PATH" $BUCKET_PATH --acl public-read

# Check if the upload was successful
if [ $? -eq 0 ]; then
  echo "✅ Success: File '$FILE_PATH' has been uploaded to '$BUCKET_PATH'."
else
  echo "❌ Error: Failed to upload '$FILE_PATH' to S3."
  exit 1
fi

# Generate and display the URL
S3_URL="https://s3.amazonaws.com/$BUCKET_PATH/$FILE_PATH"
echo "🌐 Access your file at: $S3_URL"