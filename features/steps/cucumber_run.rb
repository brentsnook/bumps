Given /^a cucumber run is performed$/ do
  ScenarioProcess.run_and_wait "cucumber -o #{feature_report_file} -r #{test_require_file} #{test_features_directory}", 'cucumber'
end
