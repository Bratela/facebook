module Facebook
  class GraphObject
    attr_reader :access_token
    attr_reader :id
    
    private
    def request path, params = { }
      uri            = URI.parse "#{API_BASE_URL}#{path}?#{params.to_params}"
      http           = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl   = true
      res            = http.get(uri.request_uri, nil)
      puts "-" * 10
      puts res
      puts "-" * 10
      res.body
    end
  end
end