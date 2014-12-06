require 'base64'


module Touth
  module Authenticator
    class << self

      def issue_access_token(resource, lifetime = Touth.access_token_lifetime)
        expires_at = Time.now.to_i + lifetime

        data = Marshal.dump({
          class:      resource.class,
          id:         resource.id,
          secret:     token_secret(resource),
          expires_at: expires_at,
        })

        data_sign = Touth.digest data

        Base64.urlsafe_encode64 [
          data,
          data_sign,
        ].join
      end

      def valid_access_token?(token)
        !!get_resource(token)
      end

      def get_resource(token)
        return unless token

        resource = Store.access_tokens[token]

        return resource if resource

        Store.access_tokens[token] = nil

        begin
          data = Base64.urlsafe_decode64(token)
          data_sign = data.slice! -32..-1

          if data_sign == Touth.digest(data)
            data = Marshal.load data

            resource = data[:class].find data[:id]

            if token_secret(resource) == data[:secret] && Time.now.to_i < data[:expires_at]
              Store.access_tokens[token] = resource
            end
          end
        rescue
          nil
        end
      end

      def token_secret(resource)
        password = resource.send Touth.password_field
        Touth.digest(password)[0..16]
      end

      def set_current(resource)
        return unless resource

        resource_name = Touth.get_resource_name resource.class.name
        Store.currents[resource_name] = resource
      end

      def current(resource_name)
        Store.currents[resource_name]
      end

    end
  end
end
