require 'faraday'
require 'multi_json'
require 'facebook/api/users'
require 'facebook/configurable'
require 'facebook/error/client_error'
require 'uri'
require 'named-parameters'
require 'net/http'

class Hash
  def to_params
    map{ |k, v| URI.escape("#{k}=#{v}") }.join("&")
  end
end

module Facebook
  class Client
    include Facebook::API::Users
    include Facebook::Configurable

    # Initializes a new Client object
    #
    # @param options [Hash]
    # @return [Facebook::Client]
    def initialize(options={})
      Facebook::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || Facebook.instance_variable_get(:"@#{key}"))
			end
    end

    # Perform an HTTP GET request
    def get(path, params={})
      request(:get, path, params)
    end

		def post(path, params={})
			request(:post, path, params)
		end

		def delete(path, params={})
			request(:delete, path, params)
		end


		has_named_parameters :'self.URI',
			:required => [ :client_id, :redirect_uri ],
			:optional => [ :scope, :display ]
		def login_url options = { }
			options[:scope] = options[:scope].to_a.join(",") if options[:scope]
			URI.parse "#{@endpoint}#{@oauth_path}?#{options.to_params}"
		end

		def logout_url options = { }
			URI.parse "#{@www}logout.php?#{options.to_params}"
		end

		has_named_parameters :request_access_token,
			:required => [ :client_id, :client_secret, :code ],
			:optional => [ :redirect_uri ]
		def request_access_token options = { }
			uri            = URI.parse "#{@endpoint}#{@access_token_path}?#{options.to_params}"
			http           = Net::HTTP.new(uri.host, uri.port)
			http.use_ssl   = true
			http.verify_mode = OpenSSL::SSL::VERIFY_NONE
			res            = http.get(uri.request_uri)

			Facebook.instance_variable_set(:"@client_id," , options[:client_id])
			Facebook.instance_variable_set(:"@client_secret", options[:client_secret])
			Facebook.instance_variable_set(:"@access_token", res.body.split("&")[0].split("=")[1])
		end 		

  private

    def request(method, path, params={}, signature_params=params)
      params[:access_token] = params[:access_token] || Facebook.credentials[:access_token]
			connection.send(method.to_sym, path, params) do |request|
        # old oauth 1.0 request.headers[:authorization] = auth_header(method.to_sym, path, signature_params).to_s
      end.env
    rescue Faraday::Error::ClientError
      raise Facebook::Error::ClientError
    end

    # Returns a Faraday::Connection object
    #
    # @return [Faraday::Connection]
    def connection
      @connection ||= Faraday.new(@endpoint, @connection_options.merge(:builder => @middleware))
    end

  end
end
