Ruby bindings for the Facebook Graph API

Basics
------
All of the examples unless otherwise specified are within the context of a 
Rails application.

Redirect the user to the Facebook authentication/authorization page:

    options = {
      :client_id    => FACEBOOK_APP_ID, 
      :redirect_uri => oauth_redirect_url,
      :scope        => [ :offline_access, :user_about_me ], # optional scope
      :display      => :popup                               # optional
    }
    redirect_to Facebook::Authorization::URI(options).to_s

Get a Facebook User object after receiving and authorization code from a
Facebook authentication redirect:

    options = { 
      :client_id          => FACEBOOK_APP_ID, 
      :client_secret      => FACEBOOK_APP_SECRET, 
      :redirect_uri       => oauth_redirect_url,
      :authorization_code => params[:code] 
    }
    user = Facebook::User.new options

    session[:current_user]           = user
    cookies.permanent[:current_user] = user.id
    
Note that the `:redirect_uri` *is* passed along with the `:authorization_code`
as described in the section for [Authentication Users in a Web Application](http://developers.facebook.com/docs/authentication/#authenticating-users-in-a-web-application)
otherwise it will be unable to request a valid access token (and subsequent 
requests will fail)

Contributing to facebook
------------------------
 
* Check out the latest master to make sure the feature hasn't been implemented 
  or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it 
  and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a 
  future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want 
  to have your own version, or is otherwise necessary, that is fine, but please 
  isolate to its own commit so I can cherry-pick around it.

Releases
--------
Please read the `RELEASENOTES` file for the details of each release. 

In general: patch releases will not include breaking changes while releases 
that bumps the major or minor components of the version string may or may not 
include breaking changes.

Author
------
[Juris Galang](http://github.com/jurisgalang/)

License
-------
Dual licensed under the MIT or GPL Version 2 licenses.  
See the MIT-LICENSE and GPL-LICENSE files for details.

Copyright (c) 2010 Juris Galang. All Rights Reserved.
