<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	 xmlns:xs="http://www.w3.org/2001/XMLSchema"
	 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	 xmlns:mml="http://www.w3.org/1998/Math/MathML"
	 xmlns:tr="http://transpect.io"
	 version="2.0">
  <xsl:import href="identity.xsl"/>
  <xsl:import href="util/symbol-map-base-uri-to-name.xsl"/>

  <xsl:variable as="document-node(element(symbols))*" name="font-maps" select="collection()[symbols]"/>

  <xsl:key name="symbol-by-number" match="symbol" use="lower-case(@number)"/>

  <xsl:template match="mml:*[@font-position]" mode="map-fonts">
    <xsl:copy>
      <xsl:apply-templates select="@* except @font-position" mode="#current"/>
      <xsl:variable as="xs:string?" name="symbol">
        <xsl:variable name="font-position" select="lower-case(@font-position)"/>
        <xsl:variable name="fontfamily" select="@fontfamily" as="xs:string?"/>
        <xsl:if test="$fontfamily">
          <xsl:variable name="selected-map" as="document-node(element(symbols))?" 
            select="($font-maps[tr:symbol-map-base-uri-to-name(.) = $fontfamily])[last()]"/>
          <xsl:sequence select="if (exists($selected-map))
                                then key('symbol-by-number', $font-position, $selected-map)/@char
                                else ()"/>
        </xsl:if>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$symbol">
          <xsl:value-of select="$symbol"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="."/>
          <xsl:comment>No font-map available, font-position: <xsl:value-of select="@font-position"/></xsl:comment>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@fontfamily[. = ('Times New Roman', 'Symbol', 'Courier New', 'MT Extra')]" mode="map-fonts"/>
  <xsl:template match="mml:*[@default-font]/@fontfamily | @default-font" mode="map-fonts" priority="2"/>
  
</xsl:stylesheet>
