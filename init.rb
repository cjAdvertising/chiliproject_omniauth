require "redmine_omniauth"

Redmine::Plugin.register :redmine_omniauth do
  name "Redmine OmniAuth plugin"
  author "cj Advertising, LLC"
  description "OmniAuth support for Redmine plugins"
  version "0.0.1"
  url "https://github.com/cjAdvertising/redmine_omniauth"
  author_url "http://cjadvertising.com"

  Redmine::Plugin.send :include, RedmineOmniauth::Plugin
end

RedmineApp::Application.config.middleware.use OmniAuth::Builder do
  configure do |config|
    config.on_failure = RedmineOmniauth::FailureEndpoint
  end
  provider :chiliproject_analytics, 
      approval_prompt: 'force',
      scope: 'userinfo.email,userinfo.profile,analytics.readonly'
  # RedmineOmniauth.registered.each { |p, args| provider p, *args }
end