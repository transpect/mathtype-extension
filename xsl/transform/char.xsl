<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  exclude-result-prefixes="xs" version="2.0"
  xmlns:tr="http://transpect.io"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../util/hexToDec.xsl"/>
  <xsl:template match="mi | mo | mn | mtext">
    <xsl:copy-of select="."/>
  </xsl:template>
  <xsl:template name="charhex">
    <xsl:param name="mt_code_value"/>
    <xsl:value-of select="codepoints-to-string(tr:hexToDec(mt_code_value))"/>
  </xsl:template>
  <xsl:template match="char/options[floor(. div 2) mod 2 = 1]">
    <xsl:attribute name="start-function"/>
  </xsl:template>
  <!-- Default char translation for mathmode -->
  <xsl:template match="char[not(variation) or variation != 'textmode']" priority="-0.1">
    <mi>
      <xsl:apply-templates select="options"/>
      <xsl:call-template name="charhex">
        <xsl:with-param name="mt_code_value" select="mt_code_value/text()"/>
      </xsl:call-template>
      <xsl:message terminate="no">
            default character match:
            <xsl:value-of select="mt_code_value/text()"
        /></xsl:message>
    </mi>
  </xsl:template>
  <xsl:template match="char[variation = 'textmode']" priority="-0.1">
    <mtext>
      <xsl:apply-templates select="options"/>
      <xsl:call-template name="charhex">
        <xsl:with-param name="mt_code_value" select="mt_code_value/text()"/>
      </xsl:call-template>
      <xsl:message terminate="no">
            default character match:
            <xsl:value-of select="mt_code_value/text()"
        /> </xsl:message>
    </mtext>
  </xsl:template>
  <xsl:template match="char[typeface = '1']">
    <mtext>
      <xsl:apply-templates select="options"/>
      <xsl:call-template name="charhex">
        <xsl:with-param name="mt_code_value" select="mt_code_value/text()"/>
      </xsl:call-template>
    </mtext>
  </xsl:template>
  <xsl:template match="char[typeface = '2']">
    <mn>
      <xsl:apply-templates select="options"/>
      <xsl:call-template name="charhex">
        <xsl:with-param name="mt_code_value" select="mt_code_value/text()"/>
      </xsl:call-template>
    </mn>
  </xsl:template>
  <xsl:template match="char[typeface = '3']">
    <mi>
      <xsl:apply-templates select="options"/>
      <xsl:call-template name="charhex">
        <xsl:with-param name="mt_code_value" select="mt_code_value/text()"/>
      </xsl:call-template>
    </mi>
  </xsl:template>
  <xsl:template match="char[typeface = '6']">
    <mo>
      <xsl:apply-templates select="options"/>
      <xsl:call-template name="charhex">
        <xsl:with-param name="mt_code_value" select="mt_code_value/text()"/>
      </xsl:call-template>
    </mo>
  </xsl:template>
  <xsl:template match="char[typeface = '7']">
    <mstyle mathsize="normal" mathvariant="bold">
      <mi>
        <xsl:apply-templates select="options"/>
        <xsl:call-template name="charhex">
          <xsl:with-param name="mt_code_value" select="mt_code_value/text()"/>
        </xsl:call-template>
      </mi>
    </mstyle>
  </xsl:template>
  <xsl:template match="char[typeface = '8']">
    <mn>
      <xsl:apply-templates select="options"/>
      <xsl:call-template name="charhex">
        <xsl:with-param name="mt_code_value" select="mt_code_value/text()"/>
      </xsl:call-template>
    </mn>
  </xsl:template>
  
  <!-- SPACING -->
  <xsl:template match="char[mt_code_value = '0xEB04' and typeface = '24']" priority="1">
    <mspace width="0.33em"/>
  </xsl:template>
  <xsl:template match="char[mt_code_value = '0xEB08' and typeface = '24']" priority="1">
    <mspace width="0.08em"/>
  </xsl:template>
</xsl:stylesheet>
