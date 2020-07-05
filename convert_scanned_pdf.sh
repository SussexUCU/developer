#/bin/bash
#
# Convert PDF scan file to searchable pdf, if it exists
#
# Image conversion of scanned PDF is probably not optimised, but (at least)
# 600 dpi appears to be necessary to get the error rate down so that it's not obvious.

TMPDIR=/tmp

if [ ! -f "$1" ]
then
  echo "File ${1} does not exist"
  exit 1
fi

if [ ! -s "$1" ]
then
  echo "File ${1} has zero bytes"
  exit 1
fi

path_root=${1%.*}
file_root=`basename "$path_root"`
ending=${1##*.}
if [[ ! ${ending} = "pdf" ]] && [[ ! ${ending} = "PDF" ]]
then
  echo "File ${1} does not end in .pdf or .PDF"
  exit 1
fi

#if pdfgrep finds the letter a, probably isn't a scan
#A bit dodgy?
# Now tests for non- zero file size

if [[ -s "${path_root}_searchable.pdf" ]] && pdfgrep -q -i "a" "${path_root}_searchable.pdf"
then
  echo "File ${path_root}_searchable.pdf already exists and is searchable"
  exit 1
fi

if pdfgrep -q -i "a" "$1"
then
  echo "File $1 already searchable PDF"
  exit 1
fi

# Now we have established that the file exists, it ends in .pdf or .PDF,
# it's probably a scan, and  that there is no data in a file with the same
# root ending in _searchable.{pdf|PDF}, as would have been created by this script.

# We can now try and convert the given file to searchable PDF

tmp_image_file="${TMPDIR}/${file_root}_HIRES_tmp.tif"
echo "ImageMagick converting $1 to tmp file $tmp_image_file"
convert -density 600 -blur 1x2 -monochrome "$1" "$tmp_image_file"
#  convert -density 150 -blur 1x2 -monochrome "$1" "$tmp_image_file"
if [[ $? ]]
then
  tesseract "$tmp_image_file" "${path_root}_searchable" pdf
  rm -f "$tmp_image_file"
fi

exit 0
