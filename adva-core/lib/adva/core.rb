require 'rails/engine'
require 'adva'

require 'simple_form'
require 'simple_slugs'
require 'simple_nested_set'
require 'simple_slugs'
require 'minimal'
require 'silence_log_tailer'

require 'routing_filter'
require 'adva/routing_filters/section_path'
require 'adva/routing_filters/section_root'
require 'adva/controller/abstract_actions'
require 'adva/controller/references'
require 'adva/view/tabs'
require 'adva/view/form'

require 'core_ext/ruby/module/include_anonymous'
require 'core_ext/rails/active_record/skip_callbacks'

module Adva
  class Core < ::Rails::Engine
    include Adva::Engine

    initializer 'adva-core.require_country_select' do
      config.to_prepare { require_dependency 'country_select' }
    end

    initializer 'adva-core.require_section_types' do
      config.to_prepare { require_dependency 'page' }
    end

    initializer 'adva-core.setup_minimal' do
      require 'inherited_resources/helpers'

      Minimal::Template::FormBuilderProxy::PROXY_TAGS << :simple_form_for << :simple_fields_for
      Minimal::Template.class_eval do
        include Minimal::Template::FormBuilderProxy
        include Minimal::Template::TranslatedTags
        include InheritedResources::Helpers::LinkTo
        include FormHelper
      end
      ActionView::Template.register_template_handler('rb', Minimal::Template::Handler)
    end

    initializer 'adva-core.register_asset_expansions' do
      ActionView::Helpers::AssetTagHelper.register_javascript_expansion(
        :common  => %w(),
        :simple  => %w(),
        :default => %w(),
        :admin   => %w( adva-core/jquery-1.4.2.min.js
                        adva-core/rails
                        adva-core/admin )
      )

      ActionView::Helpers::AssetTagHelper.register_stylesheet_expansion(
        :common  => %w( adva-core/common ),
        :simple  => %w( adva-core/simple
                        adva-core/admin/common
                        adva-core/admin/forms ),
        :default => %w( adva-core/default ),
        :admin   => %w( adva-core/admin
                        adva-core/admin/navigation
                        adva-core/admin/sidebar
                        adva-core/admin/common
                        adva-core/admin/forms
                        adva-core/admin/lists )
      )
    end
  end
end
