require 'erb'

module CodeGenerator
  module Generator
    class RubyGenerator
      attr_reader :template_filename

      def output(types)
        types.each do |type|
          output = ERB.new(File.open('lib/code_generator/templates/type.rb.erb').read, trim_mode: '-')
          File.open("output/#{type.name}.rb", 'w').puts(output.result(binding))
        end
        FileUtils.copy('lib/code_generator/templates/type_base.rb', 'output/type_base.rb')
        FileUtils.copy('lib/code_generator/templates/type_coercers.rb', 'output/type_coercers.rb')
      end

      def to_ruby_type(type)
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
          raise NotImplementedError, "#{type} is not implemented"
        end
      end
    end
  end
end
