require 'code_generator/parser'
require 'code_generator/generator'

module CodeGenerator
  def self.generate(definitions_dir)
    parser = Parser.new
    Dir.glob("./#{definitions_dir}/**/*.conf").each do |file|
      string = File.open(file, mode: 'r:UTF-8', &:read)
      parser.instance_eval(string, file)
    end

    Generator.output(parser.types)
  end
end
