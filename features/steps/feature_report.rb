Then /^the feature report will contain all remote features$/ do
  document = Nokogiri::XML(File.read pull_response_file)
  document.search('feature').each do |feature_element|
    feature = feature_element.text.strip.first
    feature_report.should match(/#{feature}/)
   end
end

Then /^the feature report should show that the feature server was not available$/ do
  feature_report.should match(/Could not retrieve features, the server was unreachable/)
end

