require 'facebook/api/utils'
require 'facebook/user'

module Facebook
	module API
		module Users
			include Facebook::API::Utils

			def me(options={})
        object_from_response(Facebook::User, :get, "/me", options)
      end

			def user(id, options={})
				object_from_response(Facebook::User, :get, "/#{id}", options)
			end

		end
	end
end

