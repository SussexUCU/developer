# developer
Place for keeping and developing open-governance tools.

## Overview

The tools are intended to help search a large number of documents for simple text strings. The searches are performed on PDF files. Basic Tools to convert office files and PDF scans to searchable PDF are included. The conversion need only be done once. The tools are bash scripts running open-source software.

There is plenty of room for improvement - the tools were written to a tight deadline by an inexperienced coder. You're very welcome to contribute - [see below](#things-that-need-improving-or-doing) for some ideas.

## Tools

#### convert_if_needed.sh

Converts a single Office file to PDF, using soffice (LibreOffice or OpenOffice).

#### check_scanned_pdf.sh

Looks for a `_searchable` version of a single PDF file and if not found, writes filename to standard output. 

#### convert_scanned_pdf.sh

Convert a scan in a single PDF file to searchable pdf, using ImageMagick and tesseract.

#### search_for.sh 

Descends directory tree from current one and performs the text search on PDF file to count occurrences of a string.

## Required software

- **pdfgrep**. For searching for text in PDF files.

- **Libreoffice/OpenOffice**. For converting Office files to PDF, tabulating results of searches.

- **ImageMagick**. For converting scans to TIFF, ready for OCR software ...

- **tesseract**. OCR software.

It's best to install the software using a package manager.  If you use Linux you will know about these already.  For Mac users, there are package managers which give you access to Unix utilities.  I use MacPorts.  There is also HomeBrew. Once you have installed MacPorts, type

>	`sudo port install pdfgrep`

>	`sudo port install ImageMagick`

>	`sudo port install tesseract`

Libreoffice is available as a standalone package. You then have to ensure that `soffice` is on your path, e.g. in your `.bashrc` file add
> `export PATH="$PATH:/Applications/LibreOffice.app/Contents/MacOS"`

## Workflow:

1. Convert office files with script `convert_if_needed.sh`. This should be run by `find`, i.e.
> 	`find . -name \"\*.doc\*\" -exec convert_if_needed.sh {} \;`

2. Check for unsearchable PDF files with `check_scanned_pdf.sh`
> `find . -name \"\*.pdf\" -exec check_scanned_pdf.sh {} \;`

3. If any are found, make searchable PDF files which are scans with script `convert_scanned_odf.sh` (this can take a long time, about a minute per page).  Resulting files from `\*.pdf` files have new ending `\*.\_searchable.pdf`.  One can use the output of `check_scanned_pdf.sh` and `xargs`, or just search again:
> 	`find . -name \"\*.pdf\" -exec convert_scanned_pdf.sh {} \;`

4. Now you have everything in the form of search PDF. To perform the text search to count occurrences and dump non-zero results to file, use the script `search_for`. The number of occurrences is given as the /<number> after the path of the file. Can do case-insensitive and recursive searches of a directory tree.
> `search_for.sh -i -R -s "string"`

5. Convert `string.txt` file, which contains files with the string, and the number of occurrences, to a table in LibreOffice (you can use Excel of course).
> `	Data -> Text to Columns...`, choose separator "/"`
The number of occurrences will be the last number in the row.

## <a name="dev"></a>Things that need improving or doing

1. `search_for.sh`
   1. Make command-line syntax more like `pdfgrep`, for which it is just a wrapper.
   1. `string.txt` format. Include search date/time in filename.
   1. `string.txt` format.  Having the number of occurrence of the string separated by a '/' is not very useful. 
1. Other scripts: write so they can descend a directory tree, and don't have to be run with `find`.
1. Script to generate URLs from filenames in `string.txt` (need to extract information from university committee pages).
1. script to generate a table of String, Filename, Number of occurrences, URL; in `.ods` or `.html` format.


## Author(s)
Mark Hindmarsh, University of Sussex, July 2020

