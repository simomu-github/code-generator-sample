module CodeGenerator
  module Element
    class Type
      attr_accessor :name, :fields

      def initialize(name)
        @name = name
        @fields = []
      end

      def add_field(field)
        fields << field
      end
    end
  end
end
