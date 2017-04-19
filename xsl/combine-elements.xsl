<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY functions "('arccos','arcsin','arctan','arg','cos','cosh','cot','coth','cov','csc','deg','det',
                       'dim','exp','gcd','glb','hom','lm','inf','int','ker','lg','lim','ln','log','lub',
                       'max','min','mod','Pr','Re','sev','sgn','sin','sinh','sup','tan','tanh','var')">
]>
<xsl:stylesheet 
	 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	 xmlns="http://www.w3.org/1998/Math/MathML"
	 xpath-default-namespace="http://www.w3.org/1998/Math/MathML"
	 version="2.0">
  <xsl:import href="identity.xsl"/>

  <xsl:param name="functions" select="&functions;"/>

  <xsl:template match="*[count(mtext) ge 2 or count(mi[@mathvariant = 'normal']) ge 2]" mode="combine-mtext">
    <xsl:element name="{local-name()}">
      <xsl:apply-templates mode="#current" select="@*"/>
      <xsl:for-each-group  select="node()"
        group-adjacent="(.[@mathvariant = 'normal' or self::mtext[not(@mathvariant)]]/local-name()[. = ('mtext', 'mi')], '')[1]">
        <xsl:choose>
          <xsl:when test="current-grouping-key()">
            <xsl:element name="{current-grouping-key()}">
              <xsl:apply-templates select="@mathvariant" mode="#current"/>
              <xsl:value-of select="current-group()/text()"/>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates mode="#current" select="current-group()"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each-group>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="*[count(mn) ge 2]" mode="combine-mn">
    <xsl:element name="{local-name()}" namespace="http://www.w3.org/1998/Math/MathML">
      <xsl:apply-templates mode="#current" select="@*"/>
      <xsl:for-each-group group-adjacent="local-name() = 'mn' and (not(preceding-sibling::*[1] = mn) or (every $a in ./@* satisfies (some $pa in preceding-sibling::*[1]/@* satisfies $pa = $a)))" select="node()">
      <xsl:choose>
        <xsl:when test="current-grouping-key()">
          <xsl:choose>
            <xsl:when test="current-group()[1]/@start-function">
              <mi mathvariant="normal">
                <xsl:apply-templates select="current-group()[1]/@* except @start-function"/>
                <xsl:value-of select="current-group()/text()"/>
              </mi>
            </xsl:when>
            <xsl:otherwise>
              <mn>
                <xsl:apply-templates select="current()[1]/@*"/>
                <xsl:value-of select="current-group()/text()"/>
              </mn>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="#current" select="current-group()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
    </xsl:element>
  </xsl:template>

  <xsl:template match="mn[text() = $functions]" mode="detect-functions">
    <mi>
      <xsl:apply-templates select="@* except @start-function" mode="#current"/>
      <xsl:value-of select="text()"/>
    </mi>
  </xsl:template>

  <xsl:template match="/" mode="combine-elements">
    <xsl:variable name="combine-mn">
      <xsl:apply-templates mode="combine-mn" select="."/>
    </xsl:variable>
    <xsl:variable name="combine-mtext">
      <xsl:apply-templates mode="combine-mtext" select="$combine-mn"/>
    </xsl:variable>
    <xsl:apply-templates mode="detect-functions" select="$combine-mtext"/>
  </xsl:template>

</xsl:stylesheet>
