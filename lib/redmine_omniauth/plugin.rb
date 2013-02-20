module RedmineOmniauth
  module Plugin
    extend ActiveSupport::Concern

    # Public: Register an Omniauth provider for a plugin.
    #
    # provider - Symbol name of the Omniauth provider strategy to use.
    # args     - Array of arguments to pass to the provider.
    #
    # Returns nothing.
    def auth_provider(provider, *args)
      RedmineOmniauth.register provider, *args
    end
  end
end