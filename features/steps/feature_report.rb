Then /^the feature report will contain all remote features$/ do
  each_feature do |feature|
    feature_report.should match(/#{feature}/)
  end
end

