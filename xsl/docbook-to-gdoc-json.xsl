<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:d="http://docbook.org/ns/docbook">

  <xsl:import href="../xslt-json/write-json.xsl" />

  <xsl:output method="text" />
  <xsl:strip-space elements="*" />

  <xsl:template match="/">
    <xsl:call-template name="write.object" />
  </xsl:template>

  <xsl:template match="d:info">
    <xsl:call-template name="write.value">
      <xsl:with-param name="is.first.value">
        <xsl:call-template name="is.first.json.value.check" />
      </xsl:with-param>
      <xsl:with-param name="value.name">title</xsl:with-param>
      <xsl:with-param name="value.data">
        <xsl:apply-templates mode="output.from.docbook.info" />
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="d:title" mode="output.from.docbook.info">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="*" mode="output.from.docbook.info" />

  <xsl:template match="d:para">
    <xsl:call-template name="write.value">
      <xsl:with-param name="is.first.value">
        <xsl:call-template name="is.first.json.value.check" />
      </xsl:with-param>
      <xsl:with-param name="value.name">para<xsl:value-of select="generate-id(.)" /></xsl:with-param>
      <xsl:with-param name="value.data">
        <xsl:apply-templates />
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="*">
    <xsl:message>Unhandled DocBook element: <xsl:value-of select="name(.)" /></xsl:message>
    <xsl:apply-templates />
    <!--
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
    -->
  </xsl:template>

  <xsl:template name="is.first.json.value.check">
    <!-- Almost always check position in relation to siblings of the current
         element's parent. -->
    <xsl:param name="context.element" select="parent::*" />
    <!-- Loop through all the child elements and add their IDs, in position()
         order, to a comma-separated list if they're not suppressed by the
         check.first.position mode templates. It might be better to base this
         check on the actual output templates so they stay in sync. -->
    <xsl:variable name="identifiers.of.elements.in.output.set">
      <xsl:for-each select="$context.element/*">
        <xsl:sort select="position()" />
        <xsl:variable name="evaluated.element.identifier">
          <xsl:apply-templates select="." mode="check.first.position" />
        </xsl:variable>
        <xsl:if test="string-length($evaluated.element.identifier) > 0">
          <xsl:value-of select="$evaluated.element.identifier" />
          <xsl:text>,</xsl:text>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <!-- Take the ID of the first element in the JSON output. It's the first 
         comma-separated value in the list. -->
    <xsl:variable name="id.of.first.element.in.output.set">
      <xsl:value-of select="substring-before($identifiers.of.elements.in.output.set, ',')" />
    </xsl:variable>
    <!-- If that first element ID matches the ID of the current element, we're
         processing the first element. An integer value other than 0 indicates
         that the current element is the first element in a JSON output set. -->
    <xsl:choose>
      <xsl:when test="contains(generate-id(.), $id.of.first.element.in.output.set) and 
                      string-length(generate-id(.)) = string-length($id.of.first.element.in.output.set)">
        <xsl:value-of select="1" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="0" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- <xsl:template match="d:info" mode="check.first.position" priority="1" /> -->

  <xsl:template match="*" mode="check.first.position">
    <!-- If another template in this mode hasn't prevented this template 
         from matching, add the element's ID to the list of output elements. -->
    <xsl:value-of select="generate-id(.)" />
  </xsl:template>
  
</xsl:stylesheet>
