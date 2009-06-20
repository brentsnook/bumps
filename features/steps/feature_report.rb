Then /^the feature report will contain all remote features$/ do
  document = Nokogiri::XML(File.read pull_response_file)
  document.search('feature').each do |feature_element|
    feature = feature_element.text.strip.first
    feature_report.should match(/#{feature}/)
   end
end

Then /^the feature report should show that features could not be pulled$/ do
  feature_report.should match(/Could not pull features/)
end

