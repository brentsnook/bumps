Then /^the command output should show that features could not be pulled$/ do
  command_output.should match(/Could not pull features/)
end

Then /^the command output should show that features could not be pushed$/ do
  command_output.should match(/Failed to push results/)
end
