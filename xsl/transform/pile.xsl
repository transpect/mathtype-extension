<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    xmlns="http://www.w3.org/1998/Math/MathML"
    version="2.0">

    <!-- The translation of a pile using this form of translation string is performed with the following steps:

    The <start> part of the translation string is output;
    The first line is translated;
    The <repeat> part of the translation string is output;
    The next line is translated;
    If there are any more lines, go back to Step 3. Otherwise, continue with the next step;
    The <end> part of the translation string is output.
    -->
    <xsl:template match="pile">
        <mtable>
            <xsl:apply-templates select="slot" mode="wrap"/>
        </mtable>
    </xsl:template>

    <xsl:template match="pile[halign='left']">
        <mtable columnalign="left">
            <xsl:apply-templates select="slot" mode="wrap"/>
        </mtable>
    </xsl:template>

    <xsl:template match="pile/slot" mode="wrap">
      <xsl:param name="horizontal-align" as="xs:string?"/>
      <xsl:param name="group-by-equal-sign" as="xs:boolean?"/>
      <mtr>
        <xsl:choose>
          <xsl:when test="$horizontal-align eq 'al' and $group-by-equal-sign">
            <xsl:for-each-group select="*" group-adjacent="exists(mt_code_value[. eq '0x003D']
                                                                 |preceding-sibling::char/mt_code_value[. eq '0x003D'])">
              <xsl:choose>
                <xsl:when test=" current-grouping-key() eq true()">
                  <mtd columnalign="left">
                    <xsl:apply-templates select="current-group()"/>
                  </mtd>
                </xsl:when>
                <xsl:otherwise>
                  <mtd columnalign="left">
                    <xsl:apply-templates select="current-group()"/>
                  </mtd>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each-group>
          </xsl:when>
          <xsl:otherwise>
            <mtd>
              <xsl:apply-templates select="."/>
            </mtd>
          </xsl:otherwise>
        </xsl:choose>
      </mtr>
    </xsl:template>

    <xsl:template match="pile[halign='right']">
        <mtable columnalign="right">
            <xsl:apply-templates select="slot" mode="wrap"/>
        </mtable>
    </xsl:template>

    <xsl:template match="pile[halign='dec']">
        <mtable groupalign="decimalpoint">
            <xsl:apply-templates select="slot" mode="wrap"/>
        </mtable>
    </xsl:template>

    <xsl:template match="pile[halign='al']">
      <mtable>
        <xsl:apply-templates select="slot" mode="wrap">
          <xsl:with-param name="horizontal-align" select="halign" as="xs:string?"/>
          <xsl:with-param name="group-by-equal-sign" as="xs:boolean?"
                          select="slot/char/mt_code_value[. eq '0x003D']
                                  and (every $i in slot
                                       satisfies exists($i/char/mt_code_value[. eq '0x003D']))"/>
        </xsl:apply-templates>
      </mtable>
    </xsl:template>

</xsl:stylesheet>
