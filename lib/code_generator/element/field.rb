module CodeGenerator
  module Element
    class Field
      attr_accessor :name, :type, :options

      def initialize(name, type, **options)
        @name = name
        @type = type
        @options = options
      end

      def nullable?
        options[:nullable] || false
      end

      def comment
        options[:comment] || ''
      end
    end
  end
end
