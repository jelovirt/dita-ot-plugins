<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <!--xsl:variable name="newline"/-->

  <xsl:template name="commonattributes">
    <xsl:param name="default-output-class"/>
    <xsl:apply-templates select="@xml:lang"/>
    <xsl:apply-templates select="@dir"/>
    <xsl:apply-templates select="@*" mode="data-attributes"/>
    <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-startprop ')]/@outputclass" mode="add-ditaval-style"/>
    <xsl:apply-templates select="." mode="set-output-class">
      <xsl:with-param name="default" select="$default-output-class"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="@*" mode="data-attributes"/>
  
  <xsl:template match="@audience |
                       @platform |
                       @product |
                       @otherprops |
                       @props |
                       @base |
                       @rev" mode="data-attributes">
    <xsl:attribute name="data-{name()}">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>
  
  <xsl:template match="@props[contains(., '(')] |
                       @base[contains(., '(')]"
                name="data-attributes.props" mode="data-attributes">
    <xsl:param name="value" select="normalize-space(.)"/>
    <xsl:attribute name="data-{substring-before($value, '(')}">
      <xsl:value-of select="substring-before(substring-after($value, '('), ')')"/>
    </xsl:attribute>
    <xsl:if test="contains($value, ' ')">
      <xsl:call-template name="data-attributes.props">
        <xsl:with-param name="value" select="substring-after($value, ' ')"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- Metadata -->

  <xsl:template name="generateCharset">
    <meta charset="UTF-8"/>
  </xsl:template>  

  <xsl:template match="*" mode="gen-user-head">
    <link rel="schema.DC" href="http://purl.org/dc/terms/"/>
  </xsl:template>

  <xsl:template name="generateDefaultCopyright"/>
  
  <xsl:template match="*[contains(@class,' topic/copyright ')]" mode="gen-metadata">
    <meta name="rights">
      <xsl:attribute name="content">
        <xsl:text>&#xA9; </xsl:text>
        <xsl:apply-templates select="*[contains(@class,' topic/copyryear ')][1]" mode="gen-metadata"/>
        <xsl:text> </xsl:text>
        <xsl:if test="*[contains(@class,' topic/copyrholder ')]">
          <xsl:value-of select="*[contains(@class,' topic/copyrholder ')]"/>
        </xsl:if>                
      </xsl:attribute>
    </meta>
  </xsl:template>
  <xsl:template match="*[contains(@class,' topic/copyryear ')]" mode="gen-metadata">
    <xsl:param name="previous" select="/.."/>
    <xsl:param name="open-sequence" select="false()"/>
    <xsl:variable name="next" select="following-sibling::*[contains(@class,' topic/copyryear ')][1]"/>
    <xsl:variable name="begin-sequence" select="@year + 1 = number($next/@year)"/>
    <xsl:choose>
      <xsl:when test="$begin-sequence">
        <xsl:if test="not($open-sequence)">
          <xsl:value-of select="@year"/>
          <xsl:text>&#x2013;</xsl:text>
        </xsl:if>
      </xsl:when>
      <xsl:when test="$next">
        <xsl:value-of select="@year"/>
        <xsl:text>, </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@year"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="$next" mode="gen-metadata">
      <xsl:with-param name="previous" select="."/>
      <xsl:with-param name="open-sequence" select="$begin-sequence"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="*[contains(@class,' topic/title ')]" mode="gen-metadata"/>
  <xsl:template match="*[contains(@class,' topic/shortdesc ')]" mode="gen-metadata">
    <xsl:variable name="shortmeta">
      <xsl:apply-templates select="*|text()" mode="text-only"/>
    </xsl:variable>
    <meta name="description">
      <xsl:attribute name="content">
        <xsl:value-of select="normalize-space($shortmeta)"/>
      </xsl:attribute>
    </meta>
  </xsl:template>
  
  <!--
  <xsl:template match="*[contains(@class,' topic/abstract ')]" mode="gen-shortdesc-metadata"/>
  <xsl:template match="*[contains(@class,' topic/source ')]/@href" mode="gen-metadata"/>
  <xsl:template match="*[contains(@class,' topic/metadata ')]/*[contains(@class,' topic/category ')]" mode="gen-metadata"/>
  <xsl:template match="@xml:lang" mode="gen-metadata"/>
  <xsl:template match="@id" mode="gen-metadata"/>
  <xsl:template match="*" mode="gen-format-metadata"/>
  <xsl:template match="*" mode="gen-type-metadata"/>
  -->
  
  <!-- Domains -->
  
  <xsl:template match="*[contains(@class,' hi-d/tt ')]" name="topic.hi-d.tt">
    <xsl:variable name="flagrules">
      <xsl:call-template name="getrules"/>
    </xsl:variable>
    <span style="font-family: monospace">
      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="setidaname"/>
      <xsl:call-template name="flagcheck"/>
      <xsl:call-template name="revtext">
        <xsl:with-param name="flagrules" select="$flagrules"/>
      </xsl:call-template>
    </span>
  </xsl:template>

</xsl:stylesheet>