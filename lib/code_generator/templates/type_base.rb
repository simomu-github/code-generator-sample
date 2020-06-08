require_relative 'type_coercers'

module Type
  class TypeBase
    class InvalidParameterError < StandardError; end
    class CoercionError < StandardError; end
    include Coercers

    class Attribute
      attr_reader :name, :type, :required

      def initialize(name, type, required)
        @name = name
        @type = type
        @required = required
      end

      def coerce(value)
        return nil if !required && value.nil?

        type.coerce(value)
      end
    end

    class << self
      def read(params)
        params.to_h.each_with_object({}) do |(key, value), hash|
          hash[key.to_sym] = defined_attributes[key.to_sym].coerce(value)
        end
      end

      def required(name, type)
        defined_attributes[name] = Attribute.new(name, type, true)
        define_methods(name)
      end

      def optional(name, type)
        defined_attributes[name] = Attribute.new(name, type, false)
        define_methods(name)
      end

      def required_attributes
        defined_attributes.select { |_name, attribute| attribute.required }
      end

      def required_attribute_keys
        required_attributes.keys
      end

      def defined_attributes
        @defined_attributes ||= {}
      end

      def define_methods(name)
        define_method(name.to_s) { attributes[name] }
        define_method("#{name}=") { |value| attributes[name] = self.class.defined_attributes[name].coerce(value) }
      end
    end

    def initialize(params = {})
      @attributes = self.class.read(params)
      raise InvalidParameterError unless valid_params?
    end

    private

    attr_reader :attributes

    def valid_params?
      self.class.required_attribute_keys.all? { |key| attributes.keys.include?(key) }
    end
  end
end
