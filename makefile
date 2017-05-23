# Your main tex file name
ARTICLE=tjumain
# The final PDF file name
NAME=样例输出

OS=$(shell uname -s)
PDF_VIEWER=SumatraPDF

default: build

clean:
ifeq ($(OS),Darwin)
	@find -E . -regex '.*\.(aux|bak|buk|log|bcf|bbl|dvi|blg|thm|toc|toe|lof|lot|out|fen|ten|ps|gz|gz\(busy\)|synctex|loa|run\.xml)$$' -exec rm -vf {} \;
else
	@find . -regextype posix-egrep -regex '.*\.(aux|bak|buk|log|bcf|bbl|dvi|blg|thm|toc|toe|lof|lot|out|fen|ten|ps|gz|gz\(busy\)|synctex|loa|run\.xml)$$' -exec rm -vf {} \;
endif
	@echo "Clean...Done!"

build:
	@xelatex ${ARTICLE}.tex
	@bibtex ${ARTICLE}
	@xelatex ${ARTICLE}.tex
	@xelatex ${ARTICLE}.tex
	@echo "Build ${ARTICLE}.pdf...Done!"
	@mv -v ${ARTICLE}.pdf "${NAME}_build`date +%y%m%d`.pdf"

cleanAll: clean
	@find . -name '${NAME}*pdf' -exec rm -v {} \;

run:
	@open "`find . -name '${NAME}*pdf'`" > /dev/null 2>&1 &

touch:
	@touch ${NAME}.pdf
	@echo 'Done.'

test:
	${PDF_VIEWER} "`find . -name '${NAME}*pdf'`" > /dev/null 2>&1 &

