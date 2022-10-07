require_relative "snapshot"

# MATRIX record (5):
# record type (5)
# options
# [nudge] if mtefOPT_NUDGE is set
# [valign] vertical alignment of matrix within container
# [h_just] horizontal alignment within columns
# [v_just] vertical alignment within columns
# [rows] number of rows
# [cols] number of columns
# [row_parts] row partition line types (see below)
# [col_parts] column partition line types (see below)
# [object list] list of lines, one for each element of the matrix, in order from
# left-to-right and top-to-bottom
# The values for valign, h_just, and v_just are described in PILE above.

# The row partition line type list consists of two-bit values for each possible
# partition line (one more than the number of rows), rounded out to the nearest
# byte. Each value determines the line style of the corresponding partition line
# (0 for none, 1 for solid, 2 for dashed, or 3 for dotted). Similarly for the
# column partition lines.

module Mathtype5
  class RecordMatrix < BinData::Record
    include Snapshot
    EXPOSED_IN_SNAPSHOT = %i(options nudge valign h_just v_just rows cols
      row_parts col_parts object_list)
    int8 :options

    record_nudge :nudge, onlyif: lambda { options & OPTIONS["mtefOPT_NUDGE"] > 0 }

    int8 :_valign
    int8 :_h_just
    int8 :_v_just
    int8 :rows
    int8 :cols

    array :_row_parts, initial_length: lambda { (rows + 4) / 4 } do
      matrix_line_byte
    end

    array :_col_parts, initial_length: lambda { (cols + 4) / 4 } do
      matrix_line_byte
    end

    array :object_list, read_until: lambda { element.record_type == 0 } do
      named_record
    end

    def valign
      VALIGN[_valign]
    end

    def h_just
      HALIGN[_h_just]
    end

    def v_just
      VALIGN[_v_just]
    end

    def truncate_parts parts, cnt
      full_parts = cnt / 4
      all = [parts.first(full_parts), parts.last]
      all.flatten[0 .. (full_parts*4 + cnt%4)]
    end

    def row_parts
      truncate_parts _row_parts, rows
    end

    def col_parts
      truncate_parts _col_parts, cols
    end
  end
end
