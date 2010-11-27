module Facebook
  class Authorization
    # Returns the authentication URL for Facebook
    #
    # @param [Hash] options the parameters as described in the [authentication
    #   section](http://developers.facebook.com/docs/authentication/#authenticating-users-in-a-web-application)
    #   of the Facebook API documentation.
    #
    # @return [URI] representing the authentication URL with the parameters
    #   supplied in the query string parameters portion.
    #
    has_named_parameters :'self.URI', 
      :required => [ :client_id, :redirect_uri ], 
      :optional => [ :scope, :display ]
    def self.URI options = { }
      options[:scope] = options[:scope].to_a.join(",") if options[:scope]
      URI.parse "#{API_BASE_URL}#{API_AUTHORIZE_PATH}?#{options.to_params}"
    end
  end
end