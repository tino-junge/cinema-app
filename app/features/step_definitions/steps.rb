Given(/^I have this config\.yml$/) do |string|
  write_file("app/config/config.yml", string)
end

Given(/^I have an empty config\.yml$/) do
  write_file("app/config/config.yml", "")
end

Given(/^there is no file in '(.+)'$/) do |path|
  expect(path).not_to be_an_existing_file
end

Given(/^there is a file in '(.+)'$/) do |path|
  write_file(path, "foobar")
end

When(/^I try to start the server$/) do
  @app = run("ruby #{app_location}")
end

Then(/^I should see an error message on the command line like this:$/) do |error_message|
  expect(@app).to have_output_on_stderr an_output_string_including(error_message)
end

Then(/^the error messages tells the path of the missing file:$/) do |path|
  expect(@app).to have_output_on_stderr an_output_string_including(path)
end

Then(/^I there are no error messages/) do
  expect(aruba.command_monitor.last_command_stopped).to equal(@app) # wait to finish
  expect(@app.stderr).to be_empty
end

