require 'erb'

module CodeGenerator
  module Generator
    class CppGenerator
      attr_reader :types

      def output(types)
        @types = types
        types.each do |type|
          output = ERB.new(File.open('lib/code_generator/templates/type.h.erb').read, trim_mode: '-')
          File.open("output/#{type.name}.h", 'w').puts(output.result(binding))

          output = ERB.new(File.open('lib/code_generator/templates/type.cpp.erb').read, trim_mode: '-')
          File.open("output/#{type.name}.cpp", 'w').puts(output.result(binding))
        end
      end

      def to_cpp_type(type, nullable)
        case type
        when :int
          type_name = type.to_s
        when :float
          type_name = type.to_s
        when :string
          type_name = 'std::string'
        when :bool
          type_name = type.to_s
        when Array
          type_name = "std::vector<#{to_cpp_type(type.first, false)}>"
        else
          raise NotImplementedError, "#{type} is not implemented" unless types.any? { |t| t.name == type }

          type_name = type.to_s.camelize
        end

        type_name = "std::optional<#{type_name}>" if nullable
        type_name
      end

      def constractor_parameter(type)
        type.fields.map do |field|
          "const #{to_cpp_type(field.type, field.nullable?)}& #{field.name.camelize(:lower)}"
        end.join(', ')
      end

      def include_headers(type)
        headers = []
        headers << '#include <vector>' if type.fields.map { |field| field.type.class }.any? { |klass| klass == Array }
        headers << '#include <optional>' if type.fields.any?(&:nullable?)
        type.fields.each do |field|
          headers << "#include \"#{field.type}.h\"" if types.any? { |t| t.name == field.type }
        end
        headers.join("\n")
      end
    end
  end
end
