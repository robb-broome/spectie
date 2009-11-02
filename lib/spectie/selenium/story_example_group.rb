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

module Spectie
  module Selenium
    class StoryExampleGroup
      include StoryExampleGroupMethods
      include ::Selenium::Client::SeleniumHelper

      selenium = nil
      selenium_config = Spec::Runner.configuration.selenium

      before :suite do
        if selenium_config.controlled? and selenium_config.start_browser_once
          selenium = ::Selenium::Client::Driver.new(selenium_config.driver_options)
          selenium.start
        end
      end

      after :suite do
        if selenium_config.controlled? and selenium_config.start_browser_once
          selenium.stop
        end
      end

      before :each do
        if selenium_config.controlled? and !selenium_config.start_browser_once
          selenium = ::Selenium::Client::Driver.new(selenium_config.driver_options)
          selenium.start
        end
        @selenium = selenium
      end

      after :each do
        if selenium_config.controlled?
          if selenium_config.start_browser_once
            selenium.delete_all_visible_cookies
          else
            selenium.stop
          end
        end
      end
    end
  end
end
