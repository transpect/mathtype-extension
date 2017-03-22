require_relative "snapshot"

# PILE record (4):

# Consists of:

# record type (4)
# options
# [nudge] if mtefOPT_NUDGE is set
# [halign] horizontal alignment
# [valign] vertical alignment
# [[RULER record]] if mtefOPT_LP_RULER is set
# [object list] list of lines contained by the pile

module Mathtype3
  class RecordPile < BinData::Record
    include Snapshot
    EXPOSED_IN_SNAPSHOT = %i(options halign valign object_list)

    nudge :nudge, onlyif: lambda { options & OPTIONS["xfLMOVE"] > 0 }

    mandatory_parameter :_options

    virtual :_tag_options, :value => lambda{ _options }

    int8 :_halign
    int8 :_valign

    record_ruler :ruler, onlyif: lambda { _options & OPTIONS["xfRULER"] > 0 }

    array :object_list, read_until: lambda { element.record_type == 0 } do
      named_record
    end

    def halign
      HALIGN[_halign]
    end

    def valign
      VALIGN[_valign]
    end

    def options
      _tag_options
    end
  end
end
