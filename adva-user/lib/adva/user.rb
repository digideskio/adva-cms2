require 'adva/engine'
require 'devise'

module Adva
  class User < ::Rails::Engine
    include Adva::Engine

    # TODO should probably happen in the client app
    # for more devise options see http://bit.ly/bwxrGg
    initializer 'adva.user.devise_setup' do
      Devise.setup do |config|
        require 'devise/orm/active_record'
        config.mailer_sender = 'please-change-me@config-initializers-devise.com'
        config.encryptor     = :bcrypt
      end
    end
  end
end