<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.w3.org/1998/Math/MathML"
    exclude-result-prefixes="xs"
    version="1.0">

    <!-- Unions and intersections -->

    <xsl:template match="tmpl[selector='tmINTER' and (not(variation='tvBO_UPPER') and not(variation='tvBO_UPPER'))]">
        <mstyle displaystyle="true">
            <mo>&#x22C2;</mo> <xsl:apply-templates select="slot[1] | pile[1]"/>
        </mstyle>
    </xsl:template>

    <xsl:template match="tmpl[selector='tmINTER' and variation='tvBO_LOWER']">
        <mstyle displaystyle="true">
            <munder>
                <mo>&#x22C2;</mo>
                <xsl:apply-templates select="slot[2] | pile[2]"/>
            </munder>
        <xsl:apply-templates select="slot[1] | pile[1]"/>
        </mstyle>
    </xsl:template>

    <xsl:template match="tmpl[selector='tmINTER']">
        <mstyle displaystyle="true">
            <munderover>
                <mo>&#x22C2;</mo>
                <xsl:apply-templates select="slot[2] | pile[2]"/>
                <xsl:apply-templates select="slot[3] | pile[3]"/>
            </munderover>
        <xsl:apply-templates select="slot[1] | pile[1]"/>
        </mstyle>
    </xsl:template>

    <xsl:template match="tmpl[selector='tmINTER' and not(variation='tvBO_SUM') and variation='tvBO_LOWER']">
      <mstyle displaystyle="true">
        <msub>
            <mo>&#x22C2;</mo>
            <xsl:apply-templates select="slot[2] | pile[2]"/>
        </msub>
        <xsl:apply-templates select="slot[1] | pile[1]"/>
    </mstyle>
    </xsl:template>

    <xsl:template match="tmpl[selector='tmINTER' and not(variation='tvBO_SUM')]">
        <mstyle displaystyle="true">
            <msubsup>
                <mo>&#x22C2;</mo>
                <xsl:apply-templates select="slot[2] | pile[2]"/>
                <xsl:apply-templates select="slot[3] | pile[3]"/>
            </msubsup>
        <xsl:apply-templates select="slot[1] | pile[1]"/>
        </mstyle>
    </xsl:template>

    <xsl:template match="tmpl[selector='tmUNION' and (not(variation='tvBO_UPPER') and not(variation='tvBO_UPPER'))]">
      <mstyle displaystyle="true">
        <mo>&#x22C3;</mo> <xsl:apply-templates select="slot[1] | pile[1]"/>
        </mstyle>
    </xsl:template>

    <xsl:template match="tmpl[selector='tmUNION' and variation='tvBO_LOWER']">
        <mstyle displaystyle="true">
            <munder>
                <mo>&#x22C3;</mo>
                <xsl:apply-templates select="slot[2] | pile[2]"/>
            </munder>
            <xsl:apply-templates select="slot[1] | pile[1]"/>
        </mstyle>
    </xsl:template>

    <xsl:template match="tmpl[selector='tmUNION']">
        <mstyle displaystyle="true">
            <munderover>
                <mo>&#x22C3;</mo>
                <xsl:apply-templates select="slot[2] | pile[2]"/>
                <xsl:apply-templates select="slot[3] | pile[3]"/>
            </munderover>
            <xsl:apply-templates select="slot[1] | pile[1]"/>
        </mstyle>
    </xsl:template>

    <xsl:template match="tmpl[selector='tmUNION' and not(variation='tvBO_SUM') and variation='tvBO_LOWER']">
        <mstyle displaystyle="true">
            <msub>
                <mo>&#x22C3;</mo>
                <xsl:apply-templates select="slot[2] | pile[2]"/>
            </msub>
        <xsl:apply-templates select="slot[1] | pile[1]"/>
        </mstyle>
    </xsl:template>

    <xsl:template match="tmpl[selector='tmUNION' and not(variation='tvBO_SUM') ]">
        <mstyle displaystyle="true">
            <msubsup>
                <mo>&#x22C3;</mo>
                <xsl:apply-templates select="slot[2] | pile[2]"/>
                <xsl:apply-templates select="slot[3] | pile[3]"/>
            </msubsup>
            <xsl:apply-templates select="slot[1] | pile[1]"/>
        </mstyle>
    </xsl:template>
</xsl:stylesheet>
