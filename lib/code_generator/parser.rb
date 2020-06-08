require 'code_generator/element'

module CodeGenerator
  class Parser
    attr_reader :types

    def initialize
      @types = []
    end

    def type(name, &block)
      type_parser = TypeParser.new(name)
      type_parser.instance_eval(&block)
      types << type_parser.parsed_type
    end

    class TypeParser
      attr_reader :parsed_type

      def initialize(name)
        @parsed_type = Element::Type.new(name)
      end

      def field(name, type, **options)
        field = Element::Field.new(name, type, **options)
        parsed_type.add_field(field)
      end
    end
  end
end
