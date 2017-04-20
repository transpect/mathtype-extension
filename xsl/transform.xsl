<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1998/Math/MathML">
  
  <xsl:strip-space elements="*"/>
  
  <xsl:preserve-space elements="mi ms mo mn mtext"/>
  
  <xsl:template match="root">
    <xsl:apply-templates select=".//mtef"/>
  </xsl:template>
  <xsl:template match="mtef[equation_options = 'inline']">
    <math>
      <xsl:apply-templates select="eqn_prefs[1]/following-sibling::*"/>
    </math>
  </xsl:template>
  <xsl:template match="mtef[equation_options = 'block']">
    <math><!--  display="block" -->
      <xsl:apply-templates select="eqn_prefs[1]/following-sibling::*"/>
    </math>
  </xsl:template>
  <xsl:template match="mtef[not(equation_options)]">
    <math>
      <xsl:apply-templates select="node() | @*"/>
    </math>
  </xsl:template>
  <xsl:template match="slot">
    <mrow>
      <xsl:apply-templates/>
    </mrow>
  </xsl:template>
  
  <!-- Non-empty text nodes -->
  <xsl:template match="text()[normalize-space()]">
    <xsl:value-of select="."/>
  </xsl:template>
  
  <!-- fail silently only for explicit elements -->
  <xsl:template match="options | end | full | mtef_version | platform | product | product_version | product_subversion"/>
  
  <!-- message for not yet matched elements -->
  <xsl:template match="*">
    <xsl:message terminate="no">
      <xsl:text>Unmatched Element: </xsl:text>
      <xsl:value-of select="local-name()"/>
    </xsl:message>
  </xsl:template>
  
  <xsl:include href="transform/int.xsl"/>
  <xsl:include href="transform/lim.xsl"/>
  <xsl:include href="transform/frac.xsl"/>
  <xsl:include href="transform/root.xsl"/>
  <xsl:include href="transform/pile.xsl"/>
  <xsl:include href="transform/char.xsl"/>
  <xsl:include href="transform/embellishment.xsl"/>
  <xsl:include href="transform/subsup.xsl"/>
  <xsl:include href="transform/sum.xsl"/>
  <xsl:include href="transform/product_coproduct.xsl"/>
  <xsl:include href="transform/union_intersection.xsl"/>
  <xsl:include href="transform/box.xsl"/>
  <xsl:include href="transform/fence.xsl"/>
  <xsl:include href="transform/arrow.xsl"/>
  <xsl:include href="transform/matrix.xsl"/>
  <xsl:include href="transform/long_embellishment.xsl"/>
  <xsl:include href="transform/long_division.xsl"/>
  
</xsl:stylesheet>
