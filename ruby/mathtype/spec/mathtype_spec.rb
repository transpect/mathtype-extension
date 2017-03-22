require "spec_helper"

require "pry"
RSpec.describe Mathtype do
  Dir.glob("spec/fixtures/input/*.bin") do |equation|
    it "converted #{equation} matches expected output" do
      xml = Mathtype::Converter.new(equation).to_xml
      expected_xml = "#{File.basename(equation, ".*")}.xml"
      # File.open("spec/fixtures/expected/" + expected_xml, "w+") do |file|
      #   file.write xml
      # end
     expected = File.open("spec/fixtures/expected/" + expected_xml).read
     expect(xml).to eq(expected)
    end
  end
end
