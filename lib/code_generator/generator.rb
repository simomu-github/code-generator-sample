require 'code_generator/generator/cpp_generator'
require 'code_generator/generator/cs_generator'
require 'code_generator/generator/ruby_generator'

module CodeGenerator
  module Generator
    class << self
      def output(types)
        register.each do |_klass, generator|
          generator.output(types)
        end
      end

      private

      def regist(klass)
        register[klass] = klass.new
      end

      def register
        @register ||= {}
      end
    end

    regist CppGenerator
    regist CsGenerator
    regist RubyGenerator
  end
end
