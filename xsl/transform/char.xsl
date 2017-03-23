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
        <xsl:text>default character match: </xsl:text>
        <xsl:value-of select="mt_code_value/text()"/>
      </xsl:message>
    </mi>
  </xsl:template>
  <xsl:template match="char[variation = 'textmode']" priority="-0.1">
    <mtext>
      <xsl:apply-templates select="options"/>
      <xsl:call-template name="charhex">
        <xsl:with-param name="mt_code_value" select="mt_code_value/text()"/>
      </xsl:call-template>
      <xsl:message terminate="no">
        <xsl:text>default character match: </xsl:text>
        <xsl:value-of select="mt_code_value/text()"/>
      </xsl:message>
    </mtext>
  </xsl:template>
  <xsl:template match="char[(128 - number(typeface)) lt 1]">
    <xsl:variable name="font">
      <!-- TODO handle mtef5 font-encoding -->
      <xsl:variable name="typeface" select="number(typeface/text()) mod 256"/>
      <!-- (128 minus typeface) mod 256 can be negative, so add 256 before to always be positive -->
      <xsl:sequence select="//font[((256 + 128 - typeface) mod 256) = $typeface]/node()"/>
    </xsl:variable>
    <mi>
      <xsl:apply-templates select="options"/>
      <xsl:if test="$font/style = 0">
        <xsl:attribute name="mathvariant">normal</xsl:attribute>
      </xsl:if>
      <xsl:if test="$font/style = 2">
        <xsl:attribute name="mathvariant">bold</xsl:attribute>
      </xsl:if>
      <!-- spec states 1 for italic and/or 2 for bold, thus 3 for bold-italic is just a guess -->
      <xsl:if test="$font/style = 3">
        <xsl:attribute name="mathvariant">bold-italic</xsl:attribute>
      </xsl:if>
      <xsl:call-template name="charhex">
        <xsl:with-param name="mt_code_value" select="mt_code_value/text()"/>
      </xsl:call-template>
    </mi>
  </xsl:template>
  <xsl:template match="char[typeface = '1']">
    <mtext>
      <xsl:apply-templates select="options"/>
      <xsl:call-template name="charhex">
        <xsl:with-param name="mt_code_value" select="mt_code_value/text()"/>
      </xsl:call-template>
    </mtext>
  </xsl:template>
  <xsl:template match="char[typeface = ('2','8')]">
    <mn>
      <xsl:apply-templates select="options"/>
      <xsl:call-template name="charhex">
        <xsl:with-param name="mt_code_value" select="mt_code_value/text()"/>
      </xsl:call-template>
    </mn>
  </xsl:template>
  <xsl:template match="char[typeface = ('3','4')]">
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

  <!-- SPACING -->
  <xsl:template match="char[mt_code_value = '0xEB04' and typeface = '24']" priority="2">
    <mspace width="0.33em"/>
  </xsl:template>
  <xsl:template match="char[mt_code_value = '0xEB08' and typeface = '24']" priority="2">
    <mspace width="0.08em"/>
  </xsl:template>
</xsl:stylesheet>
