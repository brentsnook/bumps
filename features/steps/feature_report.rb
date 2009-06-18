Then /^the feature report will contain all remote features$/ do
  report = File.read feature_report_file
  document = Nokogiri::XML(File.read pull_response_file)
  document.search('feature').each do |feature_element|
    feature = feature_element.text.strip.first
    report.should match(/#{feature}/)
   end
end
