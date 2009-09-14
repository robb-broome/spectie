require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")
require File.expand_path(File.dirname(__FILE__) + "/../../selenium_helper")

module RspecIntegrationTesting
  module Configuration
    describe Selenium do
      it "creates a configuration the first time it's accessed" do
        Spec::Runner.configuration.selenium.should_not be_nil
        Spec::Runner.configuration.selenium.class.should == Selenium
      end
      
      it "provides driver options" do
        config = Selenium.new
        config.driver_options = "blah"
        config.driver_options.should == "blah"
      end
    end
  end
end
