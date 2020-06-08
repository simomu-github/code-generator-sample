module Type
  module Coercers
    class Integer
      def self.coerce(value)
        case value
        when ::Integer
          value
        else
          raise TypeBase::CoercionError, "#{value.inspect} is not integer"
        end
      end
    end

    class Float
      def self.coerce(value)
        case value
        when ::Float
          value
        when ::Integer
          value.to_f
        else
          raise TypeBase::CoercionError, "#{value.inspect} is not float"
        end
      end
    end

    class String
      def self.coerce(value)
        case value
        when ::String
          value
        else
          raise TypeBase::CoercionError, "#{value.inspect} is not string"
        end
      end
    end

    class Bool
      def self.coerce(value)
        case value
        when ::TrueClass, ::FalseClass
          value
        else
          raise TypeBase::CoercionError, "#{value.inspect} is not bool"
        end
      end
    end

    class Array
      def self.[](klass)
        Class.new do
          define_singleton_method(:coerce) do |value|
            raise TypeBase::CoercionError.new, "#{value.inspect} is not Array" unless value.is_a?(::Array)

            value.map { |v| klass.coerce(v) }
          end
        end
      end
    end
  end
end
