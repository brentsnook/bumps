When /^I pull all remote features$/ do  
  pickle_command = File.dirname(__FILE__) + "/../../bin/pickle #{configuration_file}"
  ScenarioProcess.run_and_wait pickle_command, 'pickle'
end
