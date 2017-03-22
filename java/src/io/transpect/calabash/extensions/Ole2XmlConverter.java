package io.transpect.calabash.extensions;

import java.io.StringWriter;

import org.jruby.embed.ScriptingContainer;

public class Ole2XmlConverter {
	public static String convertFormula(String filename) {
		ScriptingContainer container = new ScriptingContainer();
		StringWriter writer = new StringWriter();
		container.setOutput(writer);
		container.runScriptlet("require 'mathtype'" + System.lineSeparator()
									  + "puts Mathtype::Converter.new(\""
									  + filename + "\").to_xml"
									  );
		
		return writer.toString();
	}
}
