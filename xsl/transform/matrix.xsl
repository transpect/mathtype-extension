<?xml version="1.0" encoding="UTF-8"?>
<!--
// =====================================================
// Matrices
// =====================================================

// matrix translation (left, center, right)
matrix/l    = "<(ns)mtable columnalign='left'>$+$n#$-$n</(ns)mtable>";
matrix      = "<(ns)mtable>$+$n#$-$n</(ns)mtable>";
matrix/r    = "<(ns)mtable columnalign='right'>$+$n#$-$n</(ns)mtable>";

// matrix line translation (left, center, right)
matrow/l   = "<(ns)mtr columnalign='left'>$+$n#$-$n</(ns)mtr>$n";
matrow     = "<(ns)mtr>$+$n#$-$n</(ns)mtr>$n";
matrow/r   = "<(ns)mtr columnalign='right'>$+$n#$-$n</(ns)mtr>$n";

// matrix element translation (except for last element) (left, center, right)
matelem/l   = "<(ns)mtd columnalign='left'>$+$n#$-$n</(ns)mtd>$n";
matelem     = "<(ns)mtd>$+$n#$-$n</(ns)mtd>$n";
matelem/r   = "<(ns)mtd columnalign='right'>$+$n#$-$n</(ns)mtd>$n";

// matrix element translation (last element only) (left, center, right)
matelem/last/l   = "<(ns)mtd columnalign='left'>$+$n#$-$n</(ns)mtd>";
matelem/last     = "<(ns)mtd>$+$n#$-$n</(ns)mtd>";
matelem/last/r   = "<(ns)mtd columnalign='right'>$+$n#$-$n</(ns)mtd>";
 -->


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0">

  <xsl:template match="matrix/h_just[text() = ('left', 'right')]">
    <xsl:attribute name="columnalign">
      <xsl:value-of select="./text()"/>
    </xsl:attribute>
  </xsl:template>
  
  <!-- Matrices TODO -->
  <xsl:template match="matrix">
    <xsl:variable name="rows" select="number(rows)"/>
    <xsl:variable name="cols" select="number(cols)"/>
    <xsl:if test="not($rows * $cols eq count(slot | pile))">
      <xsl:message terminate="no">
        <xsl:text>Number of slots/piles doesnt match table definition! </xsl:text>
        <xsl:value-of select="count(slot | pile)"/>
        <xsl:text> slot|pile. </xsl:text>
        <xsl:value-of select="$rows"/>
        <xsl:text> rows. </xsl:text>
        <xsl:value-of select="$rows"/>
        <xsl:text> cols.</xsl:text>
      </xsl:message>
    </xsl:if>
    <mtable>
      <xsl:apply-templates select="h_just"/>
      <xsl:for-each-group group-starting-with="*[(position() mod $cols) eq 0]" select="slot | pile">
        <mtr>
          <xsl:apply-templates select="current-group()"/>
        </mtr>
      </xsl:for-each-group>
    </mtable>
  </xsl:template>

  <xsl:template match="matrix/pile" priority="2">
    <mtd>
      <xsl:next-match/>
    </mtd>
  </xsl:template>
  
  <xsl:template match="matrix/slot" priority="2">
    <mtd>
      <xsl:next-match/>
    </mtd>
  </xsl:template>
</xsl:stylesheet>
