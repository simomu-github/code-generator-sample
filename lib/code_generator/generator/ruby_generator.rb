require 'erb'

module CodeGenerator
  module Generator
    class RubyGenerator
      attr_reader :types

      def output(types)
        @types = types
        types.each do |type|
          output = ERB.new(File.open('lib/code_generator/templates/type.rb.erb').read, trim_mode: '-')
          File.open("output/#{type.name}.rb", 'w').puts(output.result(binding))
        end
        FileUtils.copy('lib/code_generator/templates/type_base.rb', 'output/type_base.rb')
        FileUtils.copy('lib/code_generator/templates/type_coercers.rb', 'output/type_coercers.rb')
      end

      def to_ruby_type(type)
        @types = types
        case type
        when :int
          'Integer'
        when :float
          'Float'
        when :string
          'String'
        when :bool
          'Bool'
        when Array
          "Array[#{to_ruby_type(type.first)}]"
        else
          raise NotImplementedError, "#{type} is not implemented" unless types.any? { |t| t.name == type }

          type.to_s.camelize
        end
      end

      def requires(type)
        requires = []
        type.fields.each do |field|
          requires << "require_relative '#{field.type}'" if types.any? { |t| t.name == field.type }
        end
        requires.join("\n")
      end
    end
  end
end
