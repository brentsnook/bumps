Given /^a cucumber run is performed$/ do
  ScenarioProcess.run_and_wait "cucumber -o #{feature_report_file} #{test_cucumber_directory}", 'cucumber'
end
