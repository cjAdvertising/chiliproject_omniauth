require "redmine"
require "omniauth"
require "active_support/concern"
require "redmine_omniauth/plugin"

# Public: Redmine OmniAuth support module.
module RedmineOmniauth

  @@registered = {}

  # Public: Register an OmniAuth strategy provider.
  #
  # provider - Symbol name of the OmniAuth strategy.
  # args     - Array provider arguments.
  #
  # Returns nothing.
  def self.register(provider, *args)
    @@registered[provider.to_sym] = args
  end

  # Public: Determine whether an OmniAuth provider has been registered.
  #
  # provider - Symbol name of the OmniAuth strategy.
  #
  # Returns Boolean if the provider has been registered.
  def self.registered?(provider)
    @@registered.key? provider.to_sym
  end

  # Public: Fetch all registered Omniauth providers.
  #
  # Returns Hash registered providers with names as keys and args as values.
  def self.registered
    @@registered
  end

  # Public: OmniAuth failure endpoint which includes the provider name in URL.
  class FailureEndpoint < OmniAuth::FailureEndpoint

    # Public: Redirect to the failure endpoint based on the provider name.
    #
    # Returns Rack::Response redirect to failure endpoint URL.
    def redirect_to_failure
      message_key = env["omniauth.error.type"]
      new_path = "#{env["SCRIPT_NAME"]}#{OmniAuth.config.path_prefix}/#{env["omniauth.error.strategy"].name}/failure?message=#{message_key}#{origin_query_param}#{strategy_name_query_param}"
      Rack::Response.new(["302 Moved"], 302, "Location" => new_path).finish
    end
  end

  Redmine::Plugin.send :include, Plugin
end