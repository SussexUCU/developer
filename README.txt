
Sussex governance docs word search project

How to do a word search on the collection of PDFs, office files, and scans.


Tools:

- pdfgrep, a unix utility for searching for text in PDF files.

- Libreoffice or OpenOffice. For converting Office files to PDF, tabulating results of searches.

- ImageMagick. For converting scans to TIFF, ready for OCR software ...

- tesseract. OCR software.

- find.  Built-in unix command for searching directory tree for files.


It's best to install the software using a package manager.  If you use Linux you will know about these already.  Mac users, there are also package managers for Mac which give you access to Unix utilities.  I use MacPorts.  There is also HomeBrew. Once you have installed MacPorts, type

	sudo port install pdfgrep

Libreoffice is available as a standalone package.


Workflow:

1. Convert office files with script convert_if_needed.sh

2. Make searchable PDF files which are scans with script convert_scanned_odf.sh (this can take a long time, about a minute per page).  Resulting *.pdf files have new ending *._searchable.pdf

3. Perform the text search to count occurrences and dump non-zero results to file, with script search_for. The number of occurrences is given as the last number.

4. Convert .txt file to a table in LibreOffice (you can use Excel of course).


convert_if_needed.sh file
--------------------
Converts a single office file to PDF, using soffice.  The idea is to walk a directory tree with find. Syntax:

	convert_if_needed.sh file

So it would be run with find as (e.g.)

	find . -name "*.doc*" -exec convert_if_needed.sh {} \;


check_scanned_pdf.sh file
--------------------

Writes names of unreadable pdfs which do not have a _searchable version to standard output. To be used in conjunction with find like this:

	find . -name "*.pdf" -exec check_scanned_pdf.sh {} \;


convert_scanned_pdf.sh file
----------------------

Convert PDF scan file to searchable pdf, if it exists, and if a pdfgrep-searchable file *_searchable.pdf does not exist.
Could probably develop so it uses the output of check_scanned_pdf rather than searching the whole directory tree again.

	find . -name "*.pdf" -exec convert_scanned_pdf.sh {} \;

Image conversion of scanned PDF is probably not optimised, but (at least) 600 dpi appears to be necessary to get the error rate down so that it's not obvious.


search_for.sh [-i] [-R] -s "string"
-------------

-i  Case-insensitive
-R  Recursive, following symbolic links.

Descends directory tree from current one and performs the text search on PDF file to count occurrences of "string". Dumps pathnames of files with non-zero results to file. The number of occurrences is given as the last number, also separated by a /, to aid breaking up the data with a spreadsheet.

Equivalent to (to be executed from a directory under which all the files are stored):

	pdfgrep -i -c -H -R "string" --match-prefix-separator / . | sed '/0$/d' > string.txt

(-i gives case-insensitive)

	pdfgrep -c -H -R "STRING" --match-prefix-separator / . | sed '/0$/d' > STRING.txt


Spreadsheet operation:

	Data -> Text to Columns, choose separator "/"

Counting PDF files:

	find . -name "*.pdf" -print | wc > pdf_file_wc.txt


Mark Hindmarsh
28.06.20
03.07.20
