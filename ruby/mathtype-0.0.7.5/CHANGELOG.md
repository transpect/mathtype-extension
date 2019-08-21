# [0.2.0] - 2019-08-21
@sbulka as additional maintainer
## ADDED
- parse .eps files
- support for ruby up to 2.6
- support mathtype-futures (record 102)
## CHANGED
- matrix: output row_parts and col_parts in reading order (left-to-right or top-to-bottom)
- fix uint > 0xFF
- fix arrows pointing in both directions

# [0.1.0] - 2017-09-10
# ADDED
- parse .wmf files
# CHANGED
- further improvements on embellishments
- introduce individual BinData::Primitive type "Mtef16"
- improve tmpl fence variations

# [0.0.7.4] - 2017-02-17
devolopment adopted by @sbulka
## ADDED
- support MTEFv3 (Word Equation Editor)
## CHANGED
- files setup for distinguishing MTEFv3 from MTEFv5

# [0.0.7] - 2015-08-26
## ADDED
- information for inline/block display

# [0.0.6] - 2015-08-24
## ADDED
- handle negative MTCode-values
- more variations for template (record 3)

# [0.0.5] - 2015-08-18
## CHANGED
- arrows variations

# [0.0.4] - 2015-08-18
## CHANGED
- map numbers for alignment to strings

# [0.0.3] - 2015-08-17
## CHANGED
- reflect changes in fontsize

# [0.0.2] - 2015-08-17
## ADDED
support char embellishments

# [0.0.1] - 2015-08-14
start the project with MTEFv5 testcases by @jure