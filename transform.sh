#!/bin/bash

PATH_TO_SAXON_JAR="saxon9he.jar"

PATH_TO_XSLT_STYLESHEET="xsl/docbook-to-gdoc-json.xsl"

PATH_TO_INPUT_XML_FILE="test-content/test-topic.xml"

OUTPUT_GOOGLE_DOC_JSON_FILE="build/google-doc-source.json"

# echo "PATH_TO_SAXON_JAR: ${PATH_TO_SAXON_JAR}"

rm -rf build
mkdir build

java -cp ${PATH_TO_SAXON_JAR} net.sf.saxon.Transform \
  -o:${OUTPUT_GOOGLE_DOC_JSON_FILE} \
  -s:${PATH_TO_INPUT_XML_FILE} \
  -xsl:${PATH_TO_XSLT_STYLESHEET}
