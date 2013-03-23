<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:import href="plugin:org.dita.troff:xsl/troff/step2-base.xsl"/>

<xsl:output method="text"
            encoding="UTF-8"/>

  <xsl:template match="sectiontitle">
    <xsl:if test="../preceding-sibling::*">
      <xsl:call-template name="force-two-newlines"/>
    </xsl:if>
    <xsl:variable name="value">
      <xsl:apply-templates select="*[1]"/>
    </xsl:variable>
    <xsl:value-of select="$value"/>
    <xsl:value-of select="$newline"/>
    <xsl:call-template name="repeat">
      <xsl:with-param name="count" select="string-length($value)"/>
      <xsl:with-param name="text">=</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="*[@style = 'bold']" mode="format-text">
    <xsl:param name="current-style" select="'normal'"/>
    <xsl:text>**</xsl:text>
    <xsl:apply-templates>
      <xsl:with-param name="current-style" select="@style"/>
    </xsl:apply-templates>
    <xsl:text>**</xsl:text>
  </xsl:template>
  
  <xsl:template match="*[@style = 'italics']" mode="format-text">
    <xsl:param name="current-style" select="'normal'"/>
    <xsl:text>_</xsl:text>
    <xsl:apply-templates>
      <xsl:with-param name="current-style" select="@style"/>
    </xsl:apply-templates>
    <xsl:text>_</xsl:text>
  </xsl:template>

  <xsl:template match="*[@style = 'tt']" mode="format-text">
    <xsl:param name="current-style" select="'normal'"/>
    <xsl:text>`</xsl:text>
    <xsl:apply-templates>
      <xsl:with-param name="current-style" select="@style"/>
    </xsl:apply-templates>
    <xsl:text>`</xsl:text>
  </xsl:template>

  <!-- Utilities -->
  
  <xsl:template name="repeat">
    <xsl:param name="count" select="0"/>
    <xsl:param name="text"/>
    <xsl:if test="$count > 0">
      <xsl:value-of select="$text"/>
      <xsl:call-template name="repeat">
        <xsl:with-param name="count" select="$count - 1"/>
        <xsl:with-param name="text" select="$text"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
