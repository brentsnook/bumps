Then /^the feature directory will contain all remote features$/ do
  document = Nokogiri::XML(File.read @pull_response_file)
  document.search('feature').each do |feature_element|
    content = feature_element.text.strip
    name = feature_element.attribute('name').to_s     
    feature_file = File.join(feature_directory, name)

    feature_file.should contain(content)
   end
end
