module Touth
  module ActionControllerSupport

    module ClassMethods

      mattr_accessor :token_authentication_on

      def token_authentication_for(scope)
        scope = scope.to_s
        name = scope.gsub('::', '_').underscore

        self.token_authentication_on = {
          class:   scope.camelize.constantize,
          current: nil,
        }

        before_action :authenticate_entity_from_token!

        define_method "#{name}_signed_in?" do
          !!self.class.token_authentication_on[:current]
        end

        define_method "current_#{name}" do
          self.class.token_authentication_on[:current]
        end
      end

    end

    module InstanceMethods

    protected

      def token_authentication_header
        @token_authentication_header ||= {
          id:    request.headers['X-Auth-ID'],
          token: request.headers['X-Auth-Token'],
        }
      end

      def authenticate_entity_from_token!
        id = token_authentication_header[:id]

        model = id.present? \
          && self.class.token_authentication_on[:class].find(id)

        unless model
          return token_authentication_error! :no_entity
        end

        unless model.valid_access_token? token_authentication_header[:token]
          return token_authentication_error! :invalid_token
        end

        self.class.token_authentication_on[:current] = model
      end

      def token_authentication_error!(type)
        render nothing: true, status: :unauthorized
        false
      end

    end

  end
end
