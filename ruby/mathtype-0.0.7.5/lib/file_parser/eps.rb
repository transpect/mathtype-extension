module Mathtype
  class EpsFileParser < FileParser
    def initialize(path)
      super(path)
      extract_mtef_from_epscomment(@raw)
    end

    def extract_mtef_from_epscomment(comment)
      string64 = @raw.gsub /\r/, ""
      # d for delimiter
      d = string64[(/MathType(.)MTEF/ =~ string64) + 8]
      matches = string64.match /.*MathType#{d}MTEF#{d}(.)#{d}(.)#{d}.{2}(.*)#{d}([0-9A-F]{4})#{d}.*/m
      leading_chrs = matches[1].to_i
      trailing_chrs = matches[2].to_i - 1
      string64   = matches[3]
      mtchecksum = matches[4]
      string64.gsub! /(\n).{#{leading_chrs}}/, "\n"
      string64.gsub! /.{#{trailing_chrs}}\n/, ''
      @equation = decode string64
      unless checksum == mtchecksum
        raise ArgumentError, "Checksums do not match, expected #{mtchecksum} but got #{checksum}"
      end
    end
  end
end
