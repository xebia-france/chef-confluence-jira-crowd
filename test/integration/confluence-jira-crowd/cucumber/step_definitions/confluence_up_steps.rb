# encoding: UTF-8
require 'faraday'
require 'socket'

Given(/^the url of Confluences home page$/) do
  # the following code is really awful and really need to find out how to change it.
  @local_ip = Socket.ip_address_list[2].ip_address
end

When(/^a web user browses to the url$/) do
  connection = Faraday.new(:url => "https://#{@local_ip}",
                           :ssl => { :verify => false }) do |faraday|
    faraday.adapter Faraday.default_adapter
  end
  @response = connection.get('/setup/setuplicense.action')
end

Then(/^the connection should be successful$/) do
  @response.success?.should be_true
end

Then(/^the page status should be OK$/) do
  @response.status.should == 200
end

Then(/^the page should have the title "(.*?)"$/) do |title|
  page_title = @response.body.match(/<title>(.*?)<\/title>/)[1]
  expect(page_title).to match(title)
end
