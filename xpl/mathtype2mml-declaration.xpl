<?xml version="1.0"?>
<p:declare-step  
  xmlns:p="http://www.w3.org/ns/xproc" 
  xmlns:c="http://www.w3.org/ns/xproc-step"
  xmlns:tr="http://transpect.io" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  version="1.0"
  type="tr:mathtype2mml">

  <p:documentation>Convert an OLE-Object containing a Mathtype equation to MathML.
  Uses Jruby to create an XML-representation of the MTEF formula.
  This step requires xproc-util.
  Conversion without xproc-util is provided by tr:mathtype2mml-internal.</p:documentation>

  <p:output port="result" primary="true" sequence="true">
    <p:documentation>The MathML equation from file @href.</p:documentation>
  </p:output>
  <p:option name="href">
    <p:documentation>The equation file URI. (OLE-Object)</p:documentation>
  </p:option>
  <p:option name="debug" select="'no'"/>
  <p:option name="debug-dir-uri" select="'debug'"/>

  <p:import href="mathtype2mml-declaration-internal.xpl"/>
  <p:import href="http://transpect.io/xproc-util/store-debug/xpl/store-debug.xpl"/>

  <p:variable name="basename" select="replace($href,  '^.+/(.+)\.[a-z]+$', '$1')"/>

  <tr:mathtype2mml-internal name="mathtype2mml-internal">
	 <p:with-option name="href" select="$href"/>
  </tr:mathtype2mml-internal>

  <tr:store-debug>
    <p:input port="source">
      <p:pipe port="mtef-xml" step="mathtype2mml-internal"></p:pipe>
    </p:input>
    <p:with-option name="pipeline-step" select="concat('mathtype2mml/', $basename, '/02-mtef2xml')"/>
    <p:with-option name="active" select="$debug"/>
    <p:with-option name="base-uri" select="$debug-dir-uri"/>
  </tr:store-debug>

  <tr:store-debug>
    <p:input port="source">
      <p:pipe port="xml2mml" step="mathtype2mml-internal"></p:pipe>
    </p:input>
    <p:with-option name="pipeline-step" select="concat('mathtype2mml/', $basename, '/04-xml2mml')"/>
    <p:with-option name="active" select="$debug"/>
    <p:with-option name="base-uri" select="$debug-dir-uri"/>
  </tr:store-debug>

  <tr:store-debug>
    <p:input port="source">
      <p:pipe port="repair-subsup" step="mathtype2mml-internal"/>
    </p:input>
    <p:with-option name="pipeline-step" select="concat('mathtype2mml/', $basename, '/06-repair-subsup')"/>
    <p:with-option name="active" select="$debug"/>
    <p:with-option name="base-uri" select="$debug-dir-uri"/>
  </tr:store-debug>

  <tr:store-debug>
    <p:input port="source">
      <p:pipe port="combine-elements" step="mathtype2mml-internal"/>
    </p:input>
    <p:with-option name="pipeline-step" select="concat('mathtype2mml/', $basename, '/08-combine-elements')"/>
    <p:with-option name="active" select="$debug"/>
    <p:with-option name="base-uri" select="$debug-dir-uri"/>
  </tr:store-debug>
  
  <p:xslt>
    <p:input port="stylesheet">
      <p:inline>
        <xsl:stylesheet version="2.0" xpath-default-namespace="http://www.w3.org/1998/Math/MathML">
          <xsl:template match="@*">
            <xsl:copy/>
          </xsl:template>
          
          <xsl:template match="*">
            <xsl:element name="mml:{local-name()}" namespace="http://www.w3.org/1998/Math/MathML">
              <xsl:apply-templates select="@*, node()"/>
            </xsl:element>
          </xsl:template>
        </xsl:stylesheet>
      </p:inline>
    </p:input>
    <p:input port="parameters">
      <p:empty/>
    </p:input>
  </p:xslt>

</p:declare-step>
