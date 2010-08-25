require 'rails/engine'

module Adva
  autoload :Engine,    'adva/engine'
  autoload :Responder, 'adva/responder'
  autoload :Importers, 'adva/importers'
  autoload :Registry,  'adva/registry'

  mattr_accessor :out
  self.out = $stdout

  class << self
    def engines
      @engines ||= constants.map do |name|
        constant = const_get(name)
        constant if constant.is_a?(Class) && constant < ::Rails::Engine
      end.compact
    end

    def engine_names
      @engine_names ||= engines.map { |constant| constant.name.split('::').last }
    end
  end
end