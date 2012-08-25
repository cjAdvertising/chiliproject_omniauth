# Chiliproject OmniAuth

Provides support for [OmniAuth](http://omniauth.org) in 
[Chiliproject](http://chiliproject.org) plugins.


## Usage

Install the plugin in `vendor/plugins/chiliproject_omniauth`. In plugins which 
require OmniAuth, use `requires_redmine_plugin` to ensure the OmniAuth plugin
is loaded. Then register the desired OmniAuth strategy using `auth_provider` in
the `Redmine::Plugin.register` block:

```ruby
# vendor/plugins/chiliproject_example/init.rb

Redmine::Plugin.register :chiliproject_example do
  name 'Some example plugin that uses Twitter authorization'
  # ...

  requires_redmine_plugin :chiliproject_omniauth, '0.0.1'
  auth_provider :twitter, 'consumer_key', 'consumer_secret'
end
```

Now create a controller to handle the authorization endpoints:

```ruby
class ExampleTwitterAuthController < ApplicationController
  unloadable

  # Public: Authorize a Twitter user with OmniAuth.
  #
  # Returns nothing.
  def authorize; end

  # Public: Handle a successful Twitter user authorization.
  #
  # Returns nothing.
  def callback
    # Fetch auth hash from OmniAuth middleware.
    @auth_hash = request.env['omniauth.auth'].to_hash

    # Update or create a Twitter user record from the auth info.
    TwitterUser.find_or_create_from_auth_hash @auth_hash

    # Flash and redirect to the origin request URL.
    flash[:notice] = "Successfully authenticated Twitter user #{@auth_hash['info']['name']}"
    redirect_to request.env['omniauth.origin'] || '/'
  end

  # Public: Handle a Twitter user authorization failure.
  #
  # Returns nothing.
  def failure
    # Flash and redirect to the origin request URL.
    flash[:error] = "There was an error authenticating with Google: #{params[:message]}"
    redirect_to params[:origin] || '/'
  end
end
```

Set up routes to handle the OmniAuth endpoints:

```ruby
# vendor/plugins/chiliproject_example/routes.rb
map.with_options :controller => 'example_twitter_auth' do |routes|
  routes.with_options :conditions => {:method => :get} do |views|
    views.connect 'auth/twitter', :action => 'authorize'
    views.connect 'auth/twitter/callback', :action => 'callback'
    views.connect 'auth/twitter/failure', :action => 'failure'
  end
end
```

Notice that `auth/twitter/failure` is used rather than the usual `auth/failure`
endpoint. The default OmniAuth failure endpoint is overwritten by the plugin
to allow other plugins to handle failure for different providers. Each plugin
is responsible for the failure endpoint for each of the providers it registers.
