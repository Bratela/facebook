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
    # property :id	is defined in Facebook::GraphObject
    #
    property :first_name	
    property :last_name	
    property :name	
    property :link	
    property :about	
    property :birthday	
    property :work	
    property :education	
    property :email	
    property :website	
    property :hometown	
    property :location	
    property :bio	
    property :quotes	
    property :gender	
    property :interested_in	
    property :meeting_for	
    property :relationship_status	
    property :religion	
    property :political	
    property :verified	
    property :significant_other	
    property :timezone	
    property :third_party_id	
    property :last_updated	
    property :locale

    def initialize options = { }
      @appid        = options[:client_id]
      @appsecret    = options[:client_secret]
      @access_token = options[:access_token]
      request_access_token(options) if options[:authorization_code]
      request_profile @access_token
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