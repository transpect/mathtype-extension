<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	 xmlns="http://www.w3.org/1998/Math/MathML" 
	 xpath-default-namespace="http://www.w3.org/1998/Math/MathML"
	 version="2.0">
  
  <xsl:import href="identity.xsl"/>
  
  <xsl:template match="msub[count(node()) = 1] | msup[count(node()) = 1] | msubsup[count(node()) le 2]" mode="repair-subsup">
    <xsl:element name="{local-name()}" namespace="http://www.w3.org/1998/Math/MathML">
      <xsl:variable name="base" as="element(*)?" 
        select="(preceding-sibling::*[1] | parent::mrow[current() is *[1]]/preceding-sibling::*[1])[1]"/>
      <xsl:choose>
        <xsl:when test="exists($base)">
          <xsl:apply-templates mode="#current" select="$base">
            <xsl:with-param name="keep" select="true()"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <mrow/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates mode="#current"/>
    </xsl:element>
  </xsl:template>

  <!-- do we expect the base in front of ../mrow/mrow or even ../mrow/mrow/mrow? -->
  <xsl:template
    match="*[following-sibling::*[1]/self::msub[count(node()) = 1]] |
           *[following-sibling::*[1]/self::mrow/*[1]/self::msub[count(node()) = 1]] |
           *[following-sibling::*[1]/self::msup[count(node()) = 1]] |
           *[following-sibling::*[1]/self::mrow/*[1]/self::msup[count(node()) = 1]] |
           *[following-sibling::*[1]/self::msubsup[count(node()) le 2]] |
           *[following-sibling::*[1]/self::mrow/*[1]/self::msubsup[count(node()) le 2]]" mode="repair-subsup"  priority="1">
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
