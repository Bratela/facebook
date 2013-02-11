require 'facebook/core_ext/enumerable'
require 'facebook/core_ext/kernel'
require 'facebook/user'

module Facebook
  module API
    module Utils

    private

      # @param klass [Class]
      # @param request_method [Symbol]
      # @param path [String]
      # @param params [Hash]
      # @param options [Hash]
      # @return [Object]
      def object_from_response(klass, request_method, path, params={})
        response = send(request_method.to_sym, path, params)
        klass.from_response(response)
      end

    end
  end
end
