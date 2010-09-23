module Adva
  class Static
    module Import
      module Format
        def self.for(path)
          const_get(File.extname(path).gsub('.', '').camelize).new(path)
        end
        
        class Base
          attr_reader :path
          
          def initialize(path)
            @path = path
          end
          
          def load(target)
            data.each { |key, value| target.instance_variable_set(:"@#{key}", value) } if data.is_a?(Hash)
          end
        end
        
        class Yml < Base
          def data
            @data ||= YAML.load_file(path)
          end
        end

        class Jekyll < Base
          def data
            @data ||= begin
              file =~ /^(---\s*\n.*?\n?)^---\s*$\n?(.*)/m
              data = YAML.load($1)
              data.merge!(:body => $2) if $2
              data
            end
          end
          
          def file
            @file ||= File.read(path)
          end
        end
      end
    end
  end
end