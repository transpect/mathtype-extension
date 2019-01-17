module Mathtype
  class Mt_uint < BinData::Primitive
    uint8 :_first
    uint8 :_second, onlyif: lambda { _first == 0xFF }
    uint8 :_third, onlyif: lambda { _first == 0xFF }
    def get
      case _first
      when 0xFF
        (_third << 0x8) | _second
      else
        _first
      end
    end
  end
end

