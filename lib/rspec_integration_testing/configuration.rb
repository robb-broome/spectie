module RspecIntegrationTesting

  module ConfigurationForScenarios
    def self.included(mod)
      mod.class_eval do
        def scenarios
          @scenarios ||= Configuration.new
        end
      end
    end

    Spec::Runner::Configuration.send :include, self
  end

  class Configuration
    attr_accessor :strict
    def initialize
      self.strict = false
    end
  end

end
