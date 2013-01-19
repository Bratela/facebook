require 'facebook/default'

module Facebook
	module Configurable
		attr_writer :client_id, :client_secret, :access_token
		attr_accessor :endpoint, :www, :oauth_path, :access_token_path, :connection_options, :identity_map, :middleware

		class << self

			def keys
				@keys ||= [
					:client_id,
					:client_secret,
					:access_token,
					:endpoint,
					:www,
					:oauth_path,
					:access_token_path,
					:connection_options,
					:identity_map,
					:middleware,
				]
			end

		end

		def configure
			yield self
			self
		end

		def credentials?
			credentials.values.all?
		end

		def cache_key
			options.hash
		end

		def reset!
			Facebook::Configurable.keys.each do |key|
				instance_variable_set(:"@#{key}", Facebook::Default.options[key])
			end
			self
		end
		alias setup reset!


		def credentials
			{
				:client_id => @client_id,
				:client_secret => @client_secret,
				:access_token => @access_token,
			}
		end

		def options
			Hash[Facebook::Configurable.keys.map{|key| [key, instance_variable_get(:"@#{key}")]}]
		end

	end
end
