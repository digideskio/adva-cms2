ENV["RAILS_ENV"] = "test"
require 'rubygems'
require 'bundler/setup'
Bundler.require

app = Adva::Generators::App.new('adva-cms2-test', :target => '/tmp', :migrate => true)
app.invoke

Gem.patching('webrat', '0.7.0') do
  ActionController.send(:remove_const, :AbstractRequest)
end

require 'cucumber/rails/world'
require 'cucumber/rails/active_record'
require 'cucumber/web/tableish'
require 'webrat'
require 'webrat/core/matchers'
require 'patches/webrat/logger'
require 'test/unit/assertions'
require 'action_dispatch/testing/assertions'
require 'factory_girl'
require Adva::Core.root.join('lib/core_ext/rails/active_record/skip_callbacks')

Adva::Testing.load_factories
Adva::Testing.load_cucumber_support
Adva::Testing.load_assertions
Adva::Testing.load_helpers
World(GlobalHelpers)
Adva.out = StringIO.new('')

Webrat.configure do |config|
  config.mode = :rails
  config.open_error_files = false
end

ActionController::Base.allow_rescue = false
Cucumber::Rails::World.use_transactional_fixtures = true
Rails.backtrace_cleaner.remove_silencers!

# TODO move to adva-static and make sure it gets loaded when running a single feature file
require Adva::Static.root.join('lib/testing/test_helper')
World(TestHelper::Static)

After do
  teardown_import_directory
  teardown_export_directory
end

