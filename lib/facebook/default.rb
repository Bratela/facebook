require 'faraday'
require 'facebook/configurable'
require 'facebook/error/client_error'
require 'facebook/error/server_error'
require 'facebook/response/parse_json'
require 'facebook/response/raise_error'
require 'facebook/version'

module Facebook
	module Default
		ENDPOINT = 'https://graph.facebook.com' unless defined? Facebook::Default::ENDPOINT
		WWW = 'https://www.facebook.com/'
		OAUTH_PATH = "/oauth/authorize"
		ACCESS_TOKEN_PATH = "/oauth/access_token"

		CONNECTION_OPTIONS = {
			:headers => {
				:accept => 'application/json',
				:user_agent => "Facebook Ruby Gem #{Facebook::Version}"
			},
			:open_timeout => 5,
			:raw => true,
			:ssl => {:verify => false},
			:timeout => 10,
		} unless defined? Facebook::Default::CONNECTION_OPTIONS
		IDENTITY_MAP = false unless defined? Facebook::Default::IDENTITY_MAP
		MIDDLEWARE = Faraday::Builder.new do |builder|
			# Convert request params to "www-form-urlencoded"
			builder.use Faraday::Request::UrlEncoded
			# Handle 4xx server responses
			builder.use Facebook::Response::RaiseError, Facebook::Error::ClientError
			# Parse JSON reponse bodies using MultiJson
			builder.use Facebook::Response::ParseJson
			# Handle 5xx server responses
			builder.use Facebook::Response::RaiseError, Facebook::Error::ServerError
			# Set Faraday's HTTP adapter
			builder.adapter Faraday.default_adapter
		end unless defined? Facebook::Default::MIDDLEWARE

		class << self

			# @return [Hash]
			def options
				Hash[Facebook::Configurable.keys.map{|key| [key, send(key)]}]
			end

			# @return [String]
			def client_id
				ENV['FACEBOOK_CLIENT_ID'] || @client_id
			end

			# @return [String]
			def client_secret
				ENV['FACEBOOK_CLIENT_SECRET'] || @client_secret
			end

			# @return [String]
			def redirect_uri
				ENV['REDIRECT_URI'] || @redirect_uri
			end

			# @return [String]
			def access_token
				ENV['FACEBOOK_ACCESS_TOKEN'] || @access_token
			end

			def endpoint
				ENDPOINT
			end

			def www
				WWW
			end

			def access_token_path
				ACCESS_TOKEN_PATH
			end

			def oauth_path
				OAUTH_PATH
			end

			def connection_options
				CONNECTION_OPTIONS
			end

			def identity_map
				IDENTITY_MAP
			end

			def middleware
				MIDDLEWARE
			end

		end
	end
end

