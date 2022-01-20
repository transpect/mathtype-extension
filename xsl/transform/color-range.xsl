<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <xsl:template match="*|@*" mode="color-range">
    <xsl:copy>
      <xsl:apply-templates select="@*, node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/*" mode="color-range">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="#current"/>
      <xsl:apply-templates select="//color_def, node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="*[color]" mode="color-range">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="#current"/>
      <xsl:for-each-group select="*" group-starting-with="color">
        <xsl:choose>
          <xsl:when test="current-group()[self::color]/color_def_index[not(. = 0)]">
            <color_range index="{current-group()[self::color]/color_def_index}" xmlns="">
              <xsl:apply-templates select="current-group()[not(self::color_def)]" mode="#current"/>
            </color_range>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="current-group()[not(self::color_def)]" mode="#current"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="color_def" mode="color-range">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="#current"/>
      <xsl:apply-templates select="node(), 
                                   following-sibling::*[1][self::color]/color_def_index" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="r|g|b" mode="color-range">
    <xsl:copy>
      <xsl:value-of select="round(. * 255 div 1000)"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>