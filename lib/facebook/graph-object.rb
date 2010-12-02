module Facebook
  class PermissionRequiredException < Exception; end
  
  class GraphObject
    class << self
      def property name
        define_method name do
          instance_variable_defined?(:"@#{name}") ? \
            instance_variable_get(:"@#{name}") : \
            :permission_required
          #raise PermissionRequiredException, "Permission required to read property: #{name}" \
          #  unless instance_variable_defined? :"@#{name}"
          #instance_variable_get :"@#{name}"
        end
      end
    end

    attr_reader :access_token
    property :id
    
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