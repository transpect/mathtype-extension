<?xml version="1.0"?>
<p:declare-step  
  xmlns:p="http://www.w3.org/ns/xproc" 
  xmlns:c="http://www.w3.org/ns/xproc-step"
  xmlns:tr="http://transpect.io" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  version="1.0"
  type="tr:mathtype2mml">

  <p:import href="mtef2xml-declaration.xpl"/>
  <p:import href="http://transpect.io/xproc-util/store-debug/xpl/store-debug.xpl"/>

  <p:documentation>Convert an OLE-Object containing a Mathtype equation to MathML.
  Uses Jruby to create an XML-representation of the MTEF formula.</p:documentation>

  <p:output port="result" primary="true" sequence="true">
    <p:documentation>The MathML equation from file @href.</p:documentation>
  </p:output>
  <p:output port="mtef-xml" primary="false" sequence="true">
    <p:documentation>The xml produced by mtef2xml step.</p:documentation>
    <p:pipe port="result" step="mtef2xml"/>
  </p:output>
  <p:option name="href">
    <p:documentation>The equation file URI. (OLE-Object)</p:documentation>
  </p:option>
  <p:option name="debug" select="'no'"/>
  <p:option name="debug-dir-uri" select="'debug'"/>
  
  <p:variable name="basename" select="replace($href,  '^.+/(.+)\.[a-z]+$', '$1')"/>

  <tr:mtef2xml name="mtef2xml">
	 <p:with-option name="href" select="$href"/>
  </tr:mtef2xml>

  <tr:store-debug>
    <p:with-option name="pipeline-step" select="concat('mathtype2mml/', $basename, '/02-mtef2xml')"/>
    <p:with-option name="active" select="$debug"/>
    <p:with-option name="base-uri" select="$debug-dir-uri"/>
  </tr:store-debug>

  <p:xslt name="xml2mml">
    <p:input port="parameters">
      <p:empty/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="../xsl/transform.xsl"/>
    </p:input>
  </p:xslt>

  <tr:store-debug>
    <p:with-option name="pipeline-step" select="concat('mathtype2mml/', $basename, '/04-xml2mml')"/>
    <p:with-option name="active" select="$debug"/>
    <p:with-option name="base-uri" select="$debug-dir-uri"/>
  </tr:store-debug>

  <p:xslt initial-mode="repair-subsup" name="repair-subsup">
    <p:input port="parameters">
      <p:empty/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="../xsl/repair-subsup.xsl"/>
    </p:input>
  </p:xslt>
  
  <tr:store-debug>
    <p:with-option name="pipeline-step" select="concat('mathtype2mml/', $basename, '/06-repair-subsup')"/>
    <p:with-option name="active" select="$debug"/>
    <p:with-option name="base-uri" select="$debug-dir-uri"/>
  </tr:store-debug>
  
  <p:xslt initial-mode="combine-elements" name="combine-elements">
    <p:input port="parameters">
      <p:empty/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="../xsl/combine-elements.xsl"/>
    </p:input>
  </p:xslt>

  <tr:store-debug>
    <p:with-option name="pipeline-step" select="concat('mathtype2mml/', $basename, '/08-combine-elements')"/>
    <p:with-option name="active" select="$debug"/>
    <p:with-option name="base-uri" select="$debug-dir-uri"/>
  </tr:store-debug>

</p:declare-step>
