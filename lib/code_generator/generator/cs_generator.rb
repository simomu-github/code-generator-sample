require 'erb'

module CodeGenerator
  module Generator
    class CsGenerator
      attr_reader :types

      def output(types)
        @types = types
        types.each do |type|
          output = ERB.new(File.open('lib/code_generator/templates/type.cs.erb').read, trim_mode: '-')
          File.open("output/#{type.name.to_s.camelize}.cs", 'w').puts(output.result(binding))
        end
      end

      def to_cs_type(type, nullable)
        case type
        when :int
          type_name = type.to_s
        when :float
          type_name = type.to_s
        when :string
          type_name = type.to_s
        when :bool
          type_name = type.to_s
        when Array
          type_name = "List<#{to_cs_type(type.first, false)}>"
        else
          raise NotImplementedError, "#{type} is not implemented" unless types.any? { |t| t.name == type }

          type_name = type.to_s.camelize
        end

        type_name += '?' if nullable
        type_name
      end

      def constractor_parameter(type)
        type.fields.map do |field|
          "#{to_cs_type(field.type, field.nullable?)} #{field.name.camelize(:lower)}"
        end.join(', ')
      end
    end
  end
end
