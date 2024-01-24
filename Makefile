DOCUMENT=readme.adoc
HTML_FILE=index.html
REVEAL_FILE=reveal.html
PDF_FILE=pdf.pdf
WORD_FILE=document.docx
OUTPUT_DIR=output
CURRENT_DIR=$(shell pwd)

all: html pdf reveal

html: prepare prepare_html
	@echo "Génération du HTML..."
	@docker run --rm -v ${CURRENT_DIR}:/formation --name docascode \
		-w /formation lordashram/asciidoc-plantuml:latest asciidoctor \
		-D ${OUTPUT_DIR} -r asciidoctor-diagram --backend=html5 \
		-a linkcss \
		-o ${HTML_FILE} ${DOCUMENT}
	@# On attribue les droits à l'utilisateur courant car les fichiers générés appartiennent à root
	@sudo chown -R $$USER:$$USER ${CURRENT_DIR}
	@# On nettoie le relicat .asciidoctor
	@rm -Rf ${OUTPUT_DIR}/.asciidoctor

pdf: prepare
	@echo "Génération du PDF..."
	@docker run --rm -v ${CURRENT_DIR}:/formation --name docascode \
		-w /formation lordashram/asciidoc-plantuml:latest asciidoctor \
		-D ${OUTPUT_DIR} -r asciidoctor-pdf -d book \
		-r asciidoctor-diagram -b pdf -o ${PDF_FILE} ${DOCUMENT}
	@# On attribue les droits à l'utilisateur courant car les fichiers générés appartiennent à root
	@sudo chown -R $$USER:$$USER ${OUTPUT_DIR}/${PDF_FILE}
	@# On nettoie le relicat .asciidoctor
	@rm -Rf ${OUTPUT_DIR}/.asciidoctor
reveal: prepare prepare_reveal
	@echo "Génération de la présentation..."
	@docker run --rm -v ${CURRENT_DIR}:/formation --name docascode \
		-w /formation lordashram/nodejs-chromium:latest \
		npm install
	@docker run --rm -v ${CURRENT_DIR}:/formation --name docascode \
		-w /formation lordashram/nodejs-chromium:latest \
		npx asciidoctor-revealjs -S unsafe -D ${OUTPUT_DIR} -o ${REVEAL_FILE} -r asciidoctor-kroki ${DOCUMENT}
	# @cp -R node_modules ${OUTPUT_DIR}

word: prepare
	@echo "Génération du word..."
	# pandoc -f docbook -t docx -o readme.docx <(asciidoctor -b docbook readme.adoc -o -)
	@touch /tmp/run-adoc.sh
	@echo "#!/bin/bash" > /tmp/run-adoc.sh
	@echo "pandoc -f docbook -t docx --lua-filter=filter.lua --toc=true --reference-doc=/formation/template.docx -o /formation/${OUTPUT_DIR}/${WORD_FILE} <(asciidoctor -r asciidoctor-diagram -b docbook /formation/${DOCUMENT} -o -)" >> /tmp/run-adoc.sh
	@chmod +x /tmp/run-adoc.sh
	docker run --rm -v ${CURRENT_DIR}:/formation -v /tmp/run-adoc.sh:/tmp/run-adoc.sh --name docascode2 \
			-w /formation lordashram/asciidoc-plantuml:latest \
			/tmp/run-adoc.sh
prepare:
	@mkdir -p ${OUTPUT_DIR}
	@mkdir -p ${OUTPUT_DIR}/images

prepare_html:
	# @cp -R themes ${OUTPUT_DIR}/
	@cp -R images/* ${OUTPUT_DIR}/images/

prepare_reveal:
	# @cp -R themes ${OUTPUT_DIR}/
	@cp -R images/* ${OUTPUT_DIR}/images/