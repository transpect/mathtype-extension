module Mathtype
  class Mtef16 < BinData::Primitive
    uint8 :low, :initial_value => 0
    uint8 :high, :initial_value => 0

    def get; (high << 8) + low end
    def getlow
      self.low
    end
    def gethigh
      self.high
    end
    def set(v)
      self.low = v & 0xFF
      self.high = (v & 0xFF00) >> 8
    end
  end

  class MatrixLineByte < BinData::Primitive
    # row/columlines are represented as 2-bit values in a full byte, in reverse
    # see MATRIX RECORD (5)
    # a 3x3 matrix with rows "solid none dashed solid" would be represented as
    # 01 10 00 01 = reverse      01   00     10    01
    # a 4x4 matrix with "solid none dashed solid solid         " accordingly does
    # 01100001 00000001 =   01   00     10    01    01 00 00 00
    uint8 :_byte

    def get
      [
        (self._byte & 0x03),
        (self._byte & 0x0C) >> 2,
        (self._byte & 0x30) >> 4,
        (self._byte & 0xC0) >> 6
      ]
    end
  end
end
