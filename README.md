# mathtype-extension

An mathtype extension step for XML Calabash that converts a Mathtype Equation embedded in OLE-Object to MathML.

Incorporates (J)Ruby mathtype gem: https://github.com/sbulka/mathtype

XSLT adapted from: https://github.com/jure/mathtype_to_mathml/tree/master/lib/xsl

Written by Sebastian Bulka, le-tex publishing services GmbH

# Usage
  There are different ways to call the xproc-step.

1. Call <tr:mathtype2mml> from your pipeline.  
	This requires you to have xproc-util available in calabash, to store debug-files.  
	<p:import href="mathtype2mml-declaration-internal.xpl"/>

2. Call <tr:mathtype2mml-internal> from your pipeline.  
	No xproc-util needed, but no debug-files stored therefore.  
	The debug is available on xproc-ports, if you want to use them yourself.

3. Call example pipeline for one file.  
   See below for setting the MATHTYPE_CP variable.  
	```java -cp $MATHTYPE_CP com.xmlcalabash.drivers.Main -c file:///uri/of/transpect-config.xml mathtype-example.xpl file=file:///uri/of/bin-file.bin```

# Options
Configure tr:mathtype2mml step by passing options to it:

 * href (required):      file name (not URI) of a bin file (containing the OLE/Mathtype Equation)
 * debug:					 Output debug messages (xsl:message) if set to 'yes'. Default is 'no'.
 * debug-dir:				 If debug is set, also output intermediate results for each internal xsl-step.
 * mml-space-handling:	 How to handle Mathtype-spacing in Mathml. Possible: 'char', 'mspace'. Default: mspace  

 # Spaces
  MathML states that whitespace-characters should be normalized before rendering.
  Problems arise because in many Mathtype-equations, whitespaces are somteimes also used for indentation.
  The option for mml-space-handling was introduced so the spaces will not be normalized.
  If 'char' is chosen, the Unicode-characters for spaces are used, wrapped in &lt;mtext&gt;.  
  Opening the MathML in e.g. your browser, spaces will then be normalized as per the spec.  
  If 'mspace' is chosen, every Mathtype-space will be represented by <mspace>.  
  You can define your preferred width for each different Mathtype-Space.  
  Insert what you want to see on the mspace/@width, including unit. (e.g. '1pt' for what is called 1pt-space in Mathtype)  
  Every option has a default width:
   * em-width	Default: '1em'
   * en-width	Default: '0.33em'
   * standard-width	Default: '0.16em'
   * thin-width	Default: '0.08em'
   * hair-width	Default: '0.08em'
   * zero-width	Default: '0em'

# Found a Bug?

You can file an issue on github for inconveniences with your mathtype-formula conversion.

Its sufficient to describe your Problem in natural language, e.g:  
"In MathML output, the last parenthese is missing."  
Please attach the oleObject which contains your formula, so we can investigate what went wrong.

Note:  
It is possible that the Equation stored in the oleObject-file is different from what is displayed in the program you use.  
This can happen when a cache is not properly updated after changing the oleObject containing the formula.  
The mathtype-extension is only able to convert the content of the oleObject, which may lead to differences from what you see.  
You can check this by viewing and verifying your Equation in Mathtype-Editor/Plugin.

# Java classpath
The extension is shipped with a copy of jruby and some ruby gems.  
These need to be on your classpath, or java wont find the files.  
In addition, calabash and saxon should be somewhere in there too.

Example:   
```MATHTYPE_CP= "/path/to/calabash/distro/xmlcalabash-1.1.15-97.jar:/path/to/calabash/saxon/saxon9he.jar:/path/to/calabash/extensions/transpect/mathtype-extension/:/path/to/calabash/extensions/transpect/mathtype-extension/lib/jruby-complete-9.1.8.0.jar:/path/to/calabash/extensions/transpect/mathtype-extension/ruby/stdlib:/path/to/calabash/extensions/transpect/mathtype-extension/ruby/ruby-ole-1.2.12.1/lib:/path/to/calabash/extensions/transpect/mathtype-extension/ruby/nokogiri-1.7.0.1-java/lib:/path/to/calabash/extensions/transpect/mathtype-extension/ruby/bindata-2.3.5/lib:/path/to/calabash/extensions/transpect/mathtype-extension/ruby/mathtype-0.0.7.4/lib"```


# Compilation

If you happen to change java sources, you need to set the classpath as describe above for compilation too.  
    ```javac -target 1.7 -source 1.7 -cp $MATHTYPE_CP Ole2Xml.java Ole2XmlConverter.java```
