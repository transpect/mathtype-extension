# mathtype-extension

An mathtype extension step for XML Calabash that converts a Mathtype Equation embedded in OLE-Object to MathML.

Written by Sebastian Bulka, le-tex publishing services GmbH


Usage example:
    MATHTYPE_CP= "/path/to/calabash/distro/xmlcalabash-1.1.15-97.jar:/path/to/calabash/saxon/saxon9he.jar:/path/to/calabash/extensions/transpect/mathtype-extension/*:/path/to/calabash/extensions/transpect/mathtype-extension/ruby/stdlib:/path/to/calabash/extensions/transpect/mathtype-extension/ruby/ruby-ole-1.2.12.1/lib:/path/to/calabash/extensions/transpect/mathtype-extension/ruby/nokogiri-1.7.0.1-java/lib:/path/to/calabash/extensions/transpect/mathtype-extension/ruby/bindata-2.3.5/lib:/path/to/calabash/extensions/transpect/mathtype-extension/ruby/mathtype/lib"

    java -cp $MATHTYPE_CP com.xmlcalabash.drivers.Main -c file:///uri/of/transpect-config.xml mathtype-example.xpl

Configure tr:mathtype step by passing options to it:

 * file (required):      file name (not URI) of a bin file (containing the OLE/Mathtype Equation)
 * dir (optional): directory containing .bin files for conversion (relative or absolute; not an URI), will write *.mml files in the same directory

Compilation:

    javac -cp $MATHTYPE_CP Ole2Xml.java Ole2XmlConverter.java
