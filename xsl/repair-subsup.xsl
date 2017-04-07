<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	 xmlns="http://www.w3.org/1998/Math/MathML" 
	 xpath-default-namespace="http://www.w3.org/1998/Math/MathML"
	 version="2.0">
  
  <xsl:import href="identity.xsl"/>
  
  <xsl:template match="msub[count(node()) = 1] | msup[count(node()) = 1] | msubsup[count(node()) le 2]" mode="repair-subsup">
    <xsl:element name="{local-name()}" namespace="http://www.w3.org/1998/Math/MathML">
      <xsl:choose>
        <xsl:when test="preceding-sibling::*">
          <xsl:apply-templates mode="#current" select="preceding-sibling::*[1]">
            <xsl:with-param name="keep" select="true()"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <mrow/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="#current" select="node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template
    match="*[following-sibling::*[1]/self::msub[count(node()) = 1]] |
           *[following-sibling::*[1]/self::msup[count(node()) = 1]] |
           *[following-sibling::*[1]/self::msubsup[count(node()) le 2]]" mode="repair-subsup">
    <xsl:param name="keep" select="false()"/>
    <xsl:if test="$keep">
      <xsl:next-match/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="mmultiscripts[not(count(mprescripts/preceding-sibling::*) mod 2 = 1)]" mode="repair-subsup">
    <mmultiscripts>
      <xsl:choose>
        <xsl:when test="following-sibling::*">
          <xsl:apply-templates mode="#current" select="following-sibling::*[1]">
            <xsl:with-param name="keep" select="true()"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <mrow/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="#current" select="node()"/>
    </mmultiscripts>
  </xsl:template>

  <xsl:template match="*[preceding-sibling::*[1]/self::mmultiscripts[not(count(mprescripts/preceding-sibling::*) mod 2 = 1)]]" mode="repair-subsup">
	 <xsl:param name="keep" select="false()"/>
	 <xsl:if test="$keep">
		<xsl:next-match/>
	 </xsl:if>
  </xsl:template>
</xsl:stylesheet>
