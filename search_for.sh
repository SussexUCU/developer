#/bin/bash
#
# Search for string "foo" in PDF files, writing result to file foo.txt

CASE=""
RECURS=""

while getopts iRs: option
do
case "${option}"
in
i) CASE=-i
;;
R) RECURS=-R
;;
s) string=${OPTARG}
esac
done


pdfgrep ${CASE} ${RECURS} -c -H "$string" --match-prefix-separator / . | sed '/0$/d' > "${string}.txt"
