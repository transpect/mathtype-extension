<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY functions "('ln','max','min','cos','sin')">
]>
<xsl:stylesheet 
	 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	 xmlns="http://www.w3.org/1998/Math/MathML"
	 xpath-default-namespace="http://www.w3.org/1998/Math/MathML"
	 version="2.0">
  <xsl:import href="identity.xsl"/>

  <xsl:template match="mrow[count(*) = 1]" mode="clean-up">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="*[mrow][count(*) = 1]/mrow" mode="clean-up">
    <!-- dissolve mstyle/mrow if mrow is the only element -->
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <xsl:template match="*[local-name() = ('mtext', 'mo', 'mn')]/@mathvariant[. = 'normal']" mode="clean-up"/>

  <xsl:template match="mi[string-length(.) = 1]/@mathvariant[. = 'italic']" mode="clean-up"/>

  <xsl:template match="mi[string-length(.) gt 1]/@mathvariant[. = 'normal']" mode="clean-up"/>

</xsl:stylesheet>
