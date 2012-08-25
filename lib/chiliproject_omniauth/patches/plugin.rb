# encoding: utf-8

module ChiliprojectOmniauth
  module Patches

    # Public: Patch module to add auth_provider support for plugins.
    module Plugin
      extend Base

      # Public: Fetch the target class to patch.
      #
      # Returns Class target class.
      def self.target
        Redmine::Plugin
      end

      # Public: Instance methods to include in the patched class.
      module InstanceMethods

        # Public: Register an Omniauth provider for a plugin.
        #
        # provider - Symbol name of the Omniauth provider strategy to use.
        # args     - Array of arguments to pass to the provider.
        #
        # Returns nothing.
        def auth_provider(provider, *args)
          ChiliprojectOmniauth.register provider, *args
        end
      end
    end
  end
end
