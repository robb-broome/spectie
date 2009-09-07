begin
  selenium_client_path = "selenium/client" 
  require selenium_client_path
rescue LoadError => e
  if e.message =~ /#{Regexp.escape(selenium_client_path)}$/
    raise "selenium-client not available. Install it with sudo gem install selenium-client"
  else
    raise e
  end
end

module RspecIntegrationTesting
  class SeleniumStoryExampleGroup
    include StoryExampleGroupMethods
    include Selenium::Client::SeleniumHelper

    before :each do
      # TODO: make this configurable
      @selenium = Selenium::Client::Driver.new(
        :host => "10.211.55.127",
        :port => 4444,
        :browser => "*firefox",
        :timeout_in_seconds => 10,
        :url => "http://10.211.55.1:4567")
      @selenium.start_new_browser_session
    end
  end
end
