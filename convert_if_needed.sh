#/bin/bash
#
# Convert (MS) Office file to pdf if it exists
#
# Could build in a directory search too, incorporating find in this script.

if [ -f "$1" ]
then

   file=${1%.*}.pdf

   if [ ! -f "$file" ]
   then
#      echo "$file does not exist"
      out_dir=`dirname "$1"`
      soffice --convert-to pdf --outdir "$out_dir" "$1"
   else
      echo "$file already exists"
   fi
else
  echo "File ${1} does not exist"
fi
