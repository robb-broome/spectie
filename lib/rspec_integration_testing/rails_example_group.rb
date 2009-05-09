module RspecIntegrationTesting

  class RailsExampleGroup < Spec::Example::ExampleGroup

    class << self

      def dsl(&implementation)
        @dsl = implementation unless implementation.nil?
        @dsl
      end

      def scenario(description, options={}, backtrace=nil, &implementation)
        example(description, options, backtrace) do
          instance_eval &self.class.dsl unless self.class.dsl.nil?
          instance_eval &implementation
        end
      end

      def xscenario(description, options={}, &implementation)
        xexample description, options, &implementation
      end

    end

    [:Given, :When, :Then].each do |scenario_statement_prefix|
      define_method scenario_statement_prefix do |dsl_method, *args|
        send dsl_method, *args
      end
    end

    Spec::Example::ExampleGroupFactory.register(:integration, self)
  end
end
