<xsl:stylesheet 
	 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	 version="2.0">
  <xsl:import href="identity.xsl"/>
  <xsl:template match="msub|msup" mode="repair-subsup">
	 <xsl:element name="{local-name()}">
		<xsl:apply-templates select="preceding-sibling::*[1]" mode="#current">
		  <xsl:with-param name="keep" select="true()"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="node()" mode="#current"/>
	 </xsl:element>
  </xsl:template>

  <xsl:template match="*[following-sibling::*[1]/local-name() = 'msub']|*[following-sibling::*[1]/local-name() = 'msup']" mode="repair-subsup">
	 <xsl:param name="keep" select="false()"/>
	 <xsl:if test="$keep">
		<xsl:next-match/>
	 </xsl:if>
  </xsl:template>

  <xsl:template match="mmultiscripts" mode="repair-subsup">
	 <mmultiscripts>
      <xsl:apply-templates select="following-sibling::*[1]" mode="#current">
		  <xsl:with-param name="keep" select="true()"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="node()" mode="#current"/>
	 </mmultiscripts>
  </xsl:template>

  <xsl:template match="*[preceding-sibling::*[1]/local-name() = 'mmultiscripts']" mode="repair-subsup">
	 <xsl:param name="keep" select="false()"/>
	 <xsl:if test="$keep">
		<xsl:next-match/>
	 </xsl:if>
  </xsl:template>
</xsl:stylesheet>
