#/bin/bash
#
# Check pdf file to see if it is unsearchable, and that a searchable version
# produced by convert_scanned_pdf.sh does not exist.

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

if ! pdfgrep -q -i "a" "$1" && [[ ! -s "${path_root}_searchable.pdf" ]] && ! pdfgrep -q -i "a" "${path_root}_searchable.pdf"
then
  echo "File ${1} not searchable and ${path_root}_searchable.pdf does not exist or is not searchable"
  exit 1
fi

exit 0
