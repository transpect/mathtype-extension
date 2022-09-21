module Mathtype
  class FileParser
    attr_reader :raw
    attr_reader :equation
    def initialize(path)
      read_from_file(path)
    end

    def read_from_file(path)
      f = File.open(path, "rb")
      @raw = f.read
      f.close
    end
  end
end

require_relative "wmf.rb"
require_relative "ole.rb"

