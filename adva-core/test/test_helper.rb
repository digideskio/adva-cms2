$: << File.expand_path('../../../adva-blog/app/models', __FILE__)
$: << File.expand_path('../../../adva-cart/app/models', __FILE__)
$: << File.expand_path('../../../adva-catalog/app/models', __FILE__)
$: << File.expand_path('../../../adva-contacts/app/models', __FILE__)
$: << File.expand_path('../../../adva-core/app/models', __FILE__)
$: << File.expand_path('../../../adva-user/app/models', __FILE__)

require 'rubygems'
require 'bundler'

Bundler.setup

require 'rails'
require 'active_record'
require 'test/unit'
require 'test_declarative'
require 'database_cleaner'
require 'ruby-debug'
require 'mocha'
require 'fakefs/safe'

require 'adva-core'

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => ':memory:'
ActiveRecord::Migration.verbose = false
ActiveRecord::Migrator.up(File.expand_path('../../../adva-core/db/migrate', __FILE__))
ActiveRecord::Migrator.up(File.expand_path('../../../adva-cart/db/migrate', __FILE__))
ActiveRecord::Migrator.up(File.expand_path('../../../adva-catalog/db/migrate', __FILE__))
ActiveRecord::Migrator.up(File.expand_path('../../../adva-contacts/db/migrate', __FILE__))

DatabaseCleaner.strategy = :truncation

DIRS = { :fixtures => Pathname.new(File.expand_path('../fixtures', __FILE__)) }

require 'site'
require 'section'
require 'page'
require 'content'
require 'article'

class Test::Unit::TestCase
  def teardown
    DatabaseCleaner.clean
  end
end