require "mathtype/version"
require "bindata"
require "ole/storage"
require "nokogiri"
require_relative "records/bintypes.rb"
require_relative "records3/mtef.rb"
require_relative "records5/mtef.rb"


module Mathtype
  class Converter
    attr_reader :xml
    attr_reader :builder
    attr_reader :version
    def initialize(equation)
      ole = Ole::Storage.open(equation, "rb+")
      eq = ole.file.read("Equation Native")[28..-1]
      ole.close
      @version = eq[0].unpack('C')[0].to_i
      raise ::NotImplementedError, "Only MTEF Version 3 and 5 currently supported, version is #{version}" unless (version==3 or version==5)
      case @version
      when 3
        data = Mathtype3::Equation.read(eq).snapshot
      when 5
        data = Mathtype5::Equation.read(eq).snapshot
      end
      @builder = Nokogiri::XML::Builder.new do |xml|
        @xml = xml
        xml.root do
          process(object: data)
        end
      end
    end

    def to_xml
      @builder.to_xml
    end

    def process(element: "mtef", object:)
      if object.is_a? Hash
        case @version
        when 3
          name = Mathtype3::RECORD_NAMES[object[:record_type]]
        else
          name = Mathtype5::RECORD_NAMES[object[:record_type]]
        end
        if name
          xml.send(name) do
            (object[:payload] || {}).each do |k, v|
              process(element: k, object: v)
            end
          end
        else
          xml.send(element) do
            object.each do |k, v|
              process(element: k, object: v)
            end
          end
        end
      elsif object.is_a? Array
        object.each do |a|
          process(element: element, object: a)
        end
      else
        process_final_element(element, object)
      end
    end

    def process_final_element(element, object)
      if object.is_a? Hash
        xml.send(element, object)
      else
        xml.send(element) { xml.text object }
      end
    end
  end
end
