module Facebook
  class User < GraphObject
    requires   :client_id, :client_secret
    recognizes :authorization_code, :redirect_uri, :access_token

    # object properties as described in http://developers.facebook.com/docs/reference/api/user
    #
    # NOTE: We made this explicit so users of the class will receive a nil if 
    # the property is not available instead of a method missing - this way 
    # its easy to determine if additional permission request is required...
    #
    # attr_reader :id	is defined in Facebook::GraphObject
    #
    attr_reader :first_name	
    attr_reader :last_name	
    attr_reader :name	
    attr_reader :link	
    attr_reader :about	
    attr_reader :birthday	
    attr_reader :work	
    attr_reader :education	
    attr_reader :email	
    attr_reader :website	
    attr_reader :hometown	
    attr_reader :location	
    attr_reader :bio	
    attr_reader :quotes	
    attr_reader :gender	
    attr_reader :interested_in	
    attr_reader :meeting_for	
    attr_reader :relationship_status	
    attr_reader :religion	
    attr_reader :political	
    attr_reader :verified	
    attr_reader :significant_other	
    attr_reader :timezone	
    attr_reader :third_party_id	
    attr_reader :last_updated	
    attr_reader :locale

    def initialize options = { }
      @appid     = options[:client_id]
      @appsecret = options[:client_secret]
      request_access_token(options) if options[:authorization_code]
      request_profile options[:access_token]
    end
    
    private
    has_named_parameters :request_access_token, 
      :required => [ :client_id, :client_secret ], 
      :oneof    => [ :code, :authorization_code ],
      :optional => [ :redirect_uri ]
    def request_access_token options = { }
      options[:code] ||= options.delete(:authorization_code)
      res = request API_ACCESS_TOKEN_PATH, options
      @access_token = res.split("=")[1]
    end
    
    def request_profile access_token
      options = { :access_token => access_token || @access_token }
      res     = request "/me", options
      profile = JSON.parse(res)
      profile.each{ |k, v| instance_variable_set :"@#{k}", v }
    end
  end
end