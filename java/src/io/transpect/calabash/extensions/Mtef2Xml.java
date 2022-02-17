package io.transpect.calabash.extensions;

import java.io.StringReader;
import java.io.IOException;

import javax.xml.transform.stream.StreamSource;

import org.jruby.embed.EvalFailedException;

import com.xmlcalabash.core.XMLCalabash;
import com.xmlcalabash.core.XProcConstants;
import com.xmlcalabash.core.XProcRuntime;
import com.xmlcalabash.io.WritablePipe;
import com.xmlcalabash.library.DefaultStep;
import com.xmlcalabash.runtime.XAtomicStep;
import com.xmlcalabash.util.TreeWriter;
import net.sf.saxon.om.AttributeMap;
import net.sf.saxon.om.EmptyAttributeMap;
import net.sf.saxon.om.SingletonAttributeMap;
import com.xmlcalabash.util.TypeUtils;

import net.sf.saxon.s9api.DocumentBuilder;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.Serializer;
import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.XdmNode;
import net.sf.saxon.om.*;


@XMLCalabash(
        name = "tr:ole2xml",
        type = "{http://example.org/xmlcalabash/steps}ole2xml")

public class Mtef2Xml extends DefaultStep {
    private WritablePipe result = null;
	 private Ole2XmlConverter ole2xmlConverter;

    public Mtef2Xml(XProcRuntime runtime, XAtomicStep step) {
		  super(runtime,step);
		  this.ole2xmlConverter = new Ole2XmlConverter();
    }

    public void setOutput(String port, WritablePipe pipe) {
        result = pipe;
    }

    public void reset() {
        result.resetWriter();
    }

    private XdmNode createXMLError(String message, String file, XProcRuntime runtime){
        TreeWriter tree = new TreeWriter(runtime);
        tree.startDocument(step.getNode().getBaseURI());
				AttributeMap attrs = EmptyAttributeMap.getInstance();
				attrs = attrs.put(TypeUtils.attributeInfo(new QName("code"), "formula-error"));
				attrs = attrs.put(TypeUtils.attributeInfo(new QName("href"), file));
        tree.addStartElement(XProcConstants.c_errors, attrs);
				
        tree.addStartElement(XProcConstants.c_error,SingletonAttributeMap.of(TypeUtils.attributeInfo(new QName("code"), "error")));
        tree.addText(message);
        tree.addEndElement();
        tree.addEndElement();
        tree.endDocument();
        return tree.getResult();        
    }
		
		private String serializeNode(XdmNode node){
			try {
				
			Processor processor = new Processor(false); // False = does not required a feature from a licensed version of Saxon.
			Serializer serializer = processor.newSerializer();
			serializer.setOutputProperty(Serializer.Property.OMIT_XML_DECLARATION, "no");
			serializer.setOutputProperty(Serializer.Property.INDENT, "yes");
			return serializer.serializeNodeToString(node);}
			catch (SaxonApiException saxex) {
				return "exception";
			}
		}
		
		private String getPoolContent(NamePool pool){
			String ret = "";
			for (int i = 1024; i <1090; i++)
			{
				try {
					ret = ret + i + "-" + pool.getUnprefixedQName(i) + "|";
				} catch (Exception e){
					ret = ret + i;
				}
			}
			return ret;
		}
	 
    public void run() throws SaxonApiException {
        super.run();

        String file = getOption(new QName("href")).getString();

        TreeWriter tree = new TreeWriter(runtime);
        tree.startDocument(step.getNode().getBaseURI());
		  try {
		  		Processor proc = runtime.getProcessor();
					DocumentBuilder builder = proc.newDocumentBuilder();
					
          this.ole2xmlConverter.convertFormula(file);
					StringReader reader = new StringReader(this.ole2xmlConverter.getFormula());
					
					
					XdmNode doc = builder.build(new StreamSource(reader));
		  		tree.addSubtree(doc);

		  } catch (Exception e) {
		  		System.err.println("[ERROR] Mtef2Xml: " + e.getMessage());
		  		result.write(createXMLError(e.getMessage(), file, runtime));
		  }
        tree.endDocument();
        result.write(tree.getResult());
    }
}
