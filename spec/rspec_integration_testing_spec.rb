require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "RspecIntegrationTesting" do

  it "can be registered as an example group that gets returned as a named type" do
    Spec::Example::ExampleGroupFactory.register(:integration, RspecIntegrationTesting::StoryExampleGroup)
    example_group = Spec::Example::ExampleGroupFactory.create_example_group(:type => :integration) {}
    example_group.superclass.should == RspecIntegrationTesting::StoryExampleGroup
  end

end
