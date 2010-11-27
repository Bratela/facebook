class Hash
  def to_params
    map{ |k, v| URI.escape("#{k}=#{v}") }.join("&")
  end
end

module Facebook
  API_HOST              = "graph.facebook.com"
  API_BASE_URL          = "https://#{API_HOST}"
  API_OAUTH_PATH        = "/oauth"
  API_AUTHORIZE_PATH    = "#{API_OAUTH_PATH}/authorize"
  API_ACCESS_TOKEN_PATH = "#{API_OAUTH_PATH}/access_token"
end
