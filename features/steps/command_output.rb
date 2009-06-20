Then /^the command output should show that features could not be pulled$/ do
  command_output.should match(/Could not pull features/)
end