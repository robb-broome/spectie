require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

module RspecIntegrationTesting

  class StoryExampleGroup
    include StoryExampleGroupMethods
  end

  describe StoryExampleGroup do

    track_example_run_state

    it "supports 'xscenario' method for disabling an example" do
      example_group = Class.new(StoryExampleGroup)
      example_ran_as_scenario = false
      Kernel.expects(:warn).with { |message| message =~ /^Example disabled/  }

      example_group.xscenario "As a user, I want to make a series of requests for our mutual benefit" do
        example_ran_as_scenario = true
      end
      example_group.run(@options)

      example_ran_as_scenario.should be_false
    end

    it "supports pending scenarios" do
      example_group = Class.new(StoryExampleGroup)
      example_group.scenario "As a user, I want to make a series of requests for our mutual benefit"
      @options.reporter.expects(:example_finished).with(anything, ::Spec::Example::ExamplePendingError)

      example_group.run(@options)
    end

    it "supports 'scenario' method for creating an example" do
      example_group = Class.new(StoryExampleGroup)
      example_ran_as_scenario = false

      example_group.scenario "As a user, I want to make a series of requests for our mutual benefit" do
        example_ran_as_scenario = true
      end
      example_group.run(@options)

      example_ran_as_scenario.should be_true
    end

    [:Given, :When, :Then].each do |scenario_statement_prefix|
      it "can use #{scenario_statement_prefix} to call dsl methods from within the scenario" do
        example_group = Class.new(StoryExampleGroup) do
          class << self
            attr_accessor :scenario_statement_was_executed
          end
        end

        example_group.scenario "As a user, I want to make a series of requests for our mutual benefit" do
          send scenario_statement_prefix, :i_am_executed
        end

        dsl = example_group.dsl do
          def i_am_executed
            self.class.scenario_statement_was_executed = true
          end
        end
        example_group.run(@options)

        example_group.scenario_statement_was_executed.should be_true
      end
    end

    it "has access to the dsl methods defined on a parent example group" do
      parent_example_group = Class.new(StoryExampleGroup) do
        class << self
          attr_accessor :scenario_statement_was_executed
        end
      end
      parent_example_group.dsl do
        def i_am_executed
          self.class.scenario_statement_was_executed = true
        end
      end
      example_group = Class.new(parent_example_group)

      example_group.scenario "As a user, I want to make a series of requests for our mutual benefit" do
        Given :i_am_executed
      end
      example_group.run(@options)

      example_group.scenario_statement_was_executed.should be_true
    end

    it "can override the definition of a dsl method on a parent example group" do
      parent_example_group = Class.new(StoryExampleGroup) do
        class << self
          attr_accessor :scenario_statement_was_executed
        end
      end
      parent_example_group.dsl do
        def i_am_executed
          self.class.scenario_statement_was_executed = "parent"
        end
      end
      example_group = Class.new(parent_example_group)
      example_group.dsl do
        def i_am_executed
          self.class.scenario_statement_was_executed = "child"
        end
      end

      example_group.scenario "As a user, I want to make a series of requests for our mutual benefit" do
        Given :i_am_executed
      end
      example_group.run(@options)

      example_group.scenario_statement_was_executed.should == "child"
    end

    xit "cannot call a dsl method without Given" do
      example_group = Class.new(StoryExampleGroup)
      example_group.class_eval do
        class << self
          attr_accessor :given_was_executed
        end
      end

      example_group.scenario "As a user, I want to make a series of requests for our mutual benefit" do
        i_am_executed
      end

      dsl = example_group.dsl do
        def i_am_executed
          self.class.given_was_executed = true
        end
      end
      example_group.run(@options)

      example.should be_failed
      example.exception.should === NoMethodError
      example_group.given_was_executed.should be_false
    end

  end

end
