<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY no-main-tmpl "('tmLIM','tmARROW','tmSUB','tmSUP','tmSUBSUP')">
<!ENTITY one-main-tmpl "('tmBOX','tmSTRIKE','tmJSTATUS','tmARC','tmHAT','tmTILDE','tmVEC','tmHBRACK','tmHBRACE','tmSUMOP','tmINTOP','tmINTER','tmUNION','tmCOPROD','tmPROD','tmSUM','tmINTEG','tmOBAR','tmUBAR','tmROOT','tmINTERVAL','tmOBRACK','tmCEILING','tmFLOOR','tmDBAR','tmBAR','tmBRACK','tmBRACE','tmPAREN','tmANGLE')">
<!ENTITY two-main-tmpl "('tmDIRAC','tmLDIV','tmFRACT')">
]>
<xsl:stylesheet 
  exclude-result-prefixes="xs tr" version="2.0"
  xmlns:tr="http://transpect.io"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1998/Math/MathML">
  
  <xsl:import href="../util/hexToDec.xsl"/>
  
  <xsl:variable name="lsize">
    <full size="12pt"/>
    <sub size="58%"/>
    <sub2 size="42%"/>
    <sym size="150%"/>
    <subsym size="100%"/>
    <user1 size="75%"/>
    <user2 size="150%"/>
  </xsl:variable>
  
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
  
  <xsl:template name="mathsize">
    <xsl:variable name="tmpl-present" select="boolean(parent::tmpl or parent::*/parent::tmpl)" as="xs:boolean"/>
    <xsl:variable name="tmpl-subsup" select="parent::*/preceding-sibling::selector = &no-main-tmpl;" as="xs:boolean"/>
    <xsl:variable name="tmpl-one-main" select="((parent::*/preceding-sibling::selector = &one-main-tmpl;) and not(parent::*/preceding-sibling::*[self::slot | self::pile]))" as="xs:boolean"/>
    <xsl:variable name="tmpl-two-main" select="((parent::*/preceding-sibling::selector = &two-main-tmpl;) and not(parent::*/preceding-sibling::*[self::slot | self::pile][2]))" as="xs:boolean"/>
    <xsl:variable name="sizename" select="preceding::*[local-name() = ('full', 'sub', 'sub2', 'sym', 'subsym', 'size')][1]/local-name()"/>
    <xsl:variable name="size" as="xs:string">
      <!-- TODO: MTEF5 user-defined sizes (equation_options) -->
      <xsl:choose>
        <xsl:when test="$sizename = 'sub'">
          <xsl:value-of select="$lsize/*[2]/@size"/>
        </xsl:when>
        <xsl:when test="$sizename = 'sub2'">
          <xsl:value-of select="$lsize/*[3]/@size"/>
        </xsl:when>
        <xsl:when test="$sizename = 'sym'">
          <xsl:value-of select="$lsize/*[4]/@size"/>
        </xsl:when>
        <xsl:when test="$sizename = 'size'">
          <xsl:variable name="size" select="preceding::size[1]"/>
          <xsl:choose>
            <xsl:when test="$size/point_size">
              <xsl:variable name="size" select="-1 * (number($size/point_size) div 32)"/>
              <xsl:variable name="fullsize" select="number(replace($lsize/*[1]/@size, 'pt', ''))"/>
              <xsl:value-of select="concat(floor($size * 100 div $fullsize), '%')"/>
            </xsl:when>
            <xsl:when test="$size/dsize">
              <xsl:variable name="lsize-selector" select="$size/lsize/text() + 1"/>
              <xsl:variable name="full-size" select="number(replace($lsize/*[1]/@size, 'pt', ''))"/>
              <xsl:variable name="rel-lsize" select="if (not($size/lsize = 0)) then number(replace($lsize/*[position() = $size/lsize]/@size, '%', '')) else 100"/>
              <xsl:variable name="abs-lsize" select="($full-size * $rel-lsize) div 100"/>
              <xsl:variable name="abs-size" select="$abs-lsize + $size/dsize"/>
              <xsl:variable name="rel-size" select="floor(($abs-size * 100) div $full-size)"/>
              <xsl:value-of select="concat($rel-size, '%')"/>
            </xsl:when>
            <xsl:otherwise>
              <!-- TODO: lsize - dsize -->
              <xsl:text>100%</xsl:text>
              <xsl:if test="$debug">
                <xsl:message>
                  <xsl:text>default size match: </xsl:text>
                  <xsl:value-of select="$size/dsize"/>
                </xsl:message>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>100%</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="boolean($size) and (not($tmpl-present) or (not($tmpl-subsup) and ($tmpl-one-main or $tmpl-two-main)))">
      <xsl:attribute name="mathsize" select="$size"/>
    </xsl:if>
  </xsl:template>
  
  <!-- Default char translation for mathmode -->
  <xsl:template match="char[not(variation) or variation != 'textmode']" priority="-0.1">
    <mi>
      <xsl:apply-templates select="options"/>
      <xsl:call-template name="mathsize"/>
      <xsl:call-template name="charhex">
        <xsl:with-param name="mt_code_value" select="mt_code_value/text()"/>
      </xsl:call-template>
      <xsl:if test="$debug">
        <xsl:message terminate="no">
          <xsl:text>default character match: </xsl:text>
          <xsl:value-of select="mt_code_value/text()"/>
        </xsl:message>
      </xsl:if>
    </mi>
  </xsl:template>
  
  <!-- Default char translation for textmode -->
  <xsl:template match="char[variation = 'textmode']" priority="-0.1">
    <mtext>
      <xsl:apply-templates select="options"/>
      <xsl:call-template name="mathsize"/>
      <xsl:call-template name="charhex">
        <xsl:with-param name="mt_code_value" select="mt_code_value/text()"/>
      </xsl:call-template>
      <xsl:if test="$debug">
        <xsl:message terminate="no">
          <xsl:text>default character match: </xsl:text>
          <xsl:value-of select="mt_code_value/text()"/>
        </xsl:message>
      </xsl:if>
    </mtext>
  </xsl:template>
  
  <xsl:template match="char[//mtef/mtef_version = '5' and (128 - number(typeface)) lt 1]">
    <xsl:variable name="font_index" select="256 - number(typeface)"/>
    <xsl:variable name="font" select="(//font_style_def)[position() = $font_index]"/>
    <mi>
      <xsl:apply-templates select="options"/>
      <xsl:call-template name="mathsize"/>
      <xsl:if test="$font/char_style = 0">
        <xsl:attribute name="mathvariant">normal</xsl:attribute>
      </xsl:if>
      <xsl:if test="$font/char_style = 1">
        <xsl:attribute name="mathvariant">bold</xsl:attribute>
      </xsl:if>
      <xsl:if test="$font/char_style = 3">
        <xsl:attribute name="mathvariant">bold-italic</xsl:attribute>
      </xsl:if>
      <xsl:call-template name="charhex">
        <xsl:with-param name="mt_code_value" select="mt_code_value/text()"/>
      </xsl:call-template>
    </mi>
  </xsl:template>
  
  <xsl:template match="char[//mtef/mtef_version = '3' and (128 - number(typeface)) lt 1]">
    <xsl:variable name="font">
      <xsl:variable name="typeface" select="number(typeface/text()) mod 256"/>
      <!-- (128 minus typeface) mod 256 can be negative, so add 256 before to always be positive -->
      <xsl:sequence select="//font[((256 + 128 - typeface) mod 256) = $typeface]/node()"/>
    </xsl:variable>
    <mi>
      <xsl:apply-templates select="options"/>
      <xsl:call-template name="mathsize"/>
      <xsl:if test="$font/style = 0">
        <xsl:attribute name="mathvariant">normal</xsl:attribute>
      </xsl:if>
      <xsl:if test="$font/style = 1">
        <xsl:attribute name="mathvariant">bold</xsl:attribute>
      </xsl:if>
      <!-- spec states 1 for italic and/or 2 for bold, but seems 1 = bold, 2 = italic, 3 = bold-italic (see MTEF5 spec) -->
      <xsl:if test="$font/style = 3">
        <xsl:attribute name="mathvariant">bold-italic</xsl:attribute>
      </xsl:if>
      <xsl:call-template name="charhex">
        <xsl:with-param name="mt_code_value" select="mt_code_value/text()"/>
      </xsl:call-template>
    </mi>
  </xsl:template>
  
  <xsl:template match="char[//mtef/mtef_version = '5' and typeface = (1 to 12)]">
    <xsl:variable name="char">
      <xsl:call-template name="charhex">
        <xsl:with-param name="mt_code_value" select="mt_code_value/text()"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="element-name">
      <xsl:choose>
        <xsl:when test="variation='textmode'">mtext</xsl:when>
        <xsl:when test="typeface = ('6')">mo</xsl:when>
        <xsl:when test="typeface = ('2', '8')">mn</xsl:when>
        <xsl:when test="typeface = ('1', '11', '12')">mtext</xsl:when>
        <xsl:otherwise>mi</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="typeface" select="number(typeface/text())"/>
    <xsl:variable name="font" select="//styles[position() = $typeface]"/>
    <xsl:variable name="mathvariant">
      <xsl:choose>
        <xsl:when test="$font/font_style = '0'">normal</xsl:when>
        <xsl:when test="$font/font_style = '1'">bold</xsl:when>
        <xsl:when test="$font/font_style = '2'">italic</xsl:when>
        <xsl:when test="$font/font_style = '3'">bold-italic</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="{$element-name}" namespace="http://www.w3.org/1998/Math/MathML">
      <xsl:attribute name="mathvariant" select="$mathvariant"/>
      <xsl:apply-templates select="options"/>
      <xsl:call-template name="mathsize"/>
      <xsl:value-of select="$char"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="char[//mtef/mtef_version = '3' and typeface = (1 to 12)]">
    <xsl:variable name="char">
      <xsl:call-template name="charhex">
        <xsl:with-param name="mt_code_value" select="mt_code_value/text()"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="element-name">
      <xsl:choose>
        <xsl:when test="variation='textmode'">mtext</xsl:when>
        <xsl:when test="typeface = ('6')">mo</xsl:when>
        <xsl:when test="typeface = ('2', '8')">mn</xsl:when>
        <xsl:when test="typeface = ('1', '11', '12')">mtext</xsl:when>
        <xsl:otherwise>mi</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="{$element-name}" namespace="http://www.w3.org/1998/Math/MathML">
      <xsl:if test="typeface = '7'">
        <xsl:attribute name="mathvariant" select="'bold'"/>
      </xsl:if>
      <xsl:apply-templates select="options"/>
      <xsl:if test="not(ancestor::tmpl[selector = ('tmSUB', 'tmSUP', 'tmSUBSUP')])">
        <xsl:call-template name="mathsize"/>
      </xsl:if>
      <xsl:call-template name="charhex">
        <xsl:with-param name="mt_code_value" select="mt_code_value/text()"/>
      </xsl:call-template>
    </xsl:element>
  </xsl:template>

  <!-- SPACING -->
  
  <xsl:variable name="mtcode-fontmap" select="document('http://transpect.io/fontmaps/MathType_MTCode.xml')" as="element(symbols)"/>
  
  <xsl:variable name="code-range" select="$mtcode-fontmap//symbol/@number" as="attribute(number)*"/>
  
  <xsl:template match="char[lower-case(replace(mt_code_value, '^0x', '')) = (for $i in $code-range return lower-case($i)) 
                            and typeface = '24']" priority="2">
    <xsl:variable name="code-value" select="replace(mt_code_value, '^0x', '')" as="xs:string"/>
    <mtext><xsl:value-of select="$mtcode-fontmap//symbol[lower-case(@number) eq lower-case($code-value)]/@char"/></mtext>
  </xsl:template>

  <!-- BULLET -->
  <xsl:template match="char[mt_code_value = '0xE98F' and typeface = '11']" priority="2">
    <mo>&#x2022;</mo>
  </xsl:template>
  
</xsl:stylesheet>
