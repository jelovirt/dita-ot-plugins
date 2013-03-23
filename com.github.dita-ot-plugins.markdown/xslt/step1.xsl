<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
  
  <xsl:import href="plugin:org.dita.troff:xsl/dita2troff-step1-shell.xsl"/>
  
  <xsl:template match="*[contains(@class,' topic/lines ')]">
    <block>
      <xsl:attribute name="xml:space">preserve</xsl:attribute>
      <xsl:call-template name="debug"/>
      <xsl:apply-templates/>
    </block>
  </xsl:template>

  <xsl:template match="*[contains(@class,' topic/pre ')]">
    <block style="tt" indent="4">
      <xsl:attribute name="xml:space">preserve</xsl:attribute>
      <xsl:call-template name="debug"/>
      <xsl:apply-templates/>
    </block>
  </xsl:template>

  <xsl:template match="*[contains(@class,' topic/ul ')]/*[contains(@class,' topic/li ')]">
    <block leadin="*   " indent="4" compact="yes">
      <xsl:call-template name="debug"/>
      <xsl:apply-templates/>
    </block>
  </xsl:template>
  
  <xsl:template match="*[contains(@class,' topic/ol ')]/*[contains(@class,' topic/li ')]">
    <block leadin="1.  " indent="4" compact="yes">
      <xsl:call-template name="debug"/>
      <xsl:apply-templates/>
    </block>
  </xsl:template>

</xsl:stylesheet>