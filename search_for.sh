#/bin/bash
#
# Search for string "foo" in PDF files, writing result to file foo.txt

usage() { echo "Usage: $0 [-h] [-i] [-o] <string> " 1>&2; }

CASE=""
OUT_DIR=""
DATE_TIME=`date -u "+%Y-%m-%d_%H:%M"`

while getopts ':hio' option
do
case "${option}"
in
i) CASE=-i
;;
o) OUT_DIR=${OPTARG}/
;;
h) usage; exit 0
;;
*) usage; exit 1
;;
esac
done

shift $((OPTIND - 1))

if (($# == 0))
then
    echo "search_for.sh: error: no search string given"
    exit 1
else
  string="$1"
fi

results_file="${OUT_DIR}${string}_${DATE_TIME}.txt"

pdfgrep ${CASE} -R -c -H "$string" --match-prefix-separator / . | sed '/0$/d' > "${results_file}"

exit 0
