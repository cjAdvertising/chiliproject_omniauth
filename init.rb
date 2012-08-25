# encoding: utf-8

require 'redmine'
require 'chiliproject_omniauth'

Redmine::Plugin.register :chiliproject_omniauth do
  name 'Chiliproject OmniAuth plugin'
  author 'cj Advertising, LLC'
  description 'OmniAuth support for plugins'
  version '0.0.1'
  url 'https://github.com/cjAdvertising/chiliproject_omniauth'
  author_url 'http://cjadvertising.com'

  ChiliprojectOmniauth::Patches::Plugin.patch
end

config.middleware.use OmniAuth::Builder do
  configure do |config|
    config.on_failure = ChiliprojectOmniauth::FailureEndpoint
  end
  ChiliprojectOmniauth.registered.each { |p, args| provider p, *args }
end