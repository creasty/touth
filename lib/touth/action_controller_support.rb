module Touth
  module ActionControllerSupport
    module ClassMethods

      mattr_accessor :token_authorized_resources

      def token_authentication_for(resource_name)
        self.token_authorized_resources ||= {}

        unless @_init_token_authenticator_hook
          prepend_before_action :set_token_authorized_resource!
          @_init_token_authenticator_hook = true
        end

        resource_name = Touth.get_resource_name resource_name
        callback_name = "authenticate_#{resource_name}!".to_sym

        unless method_defined? callback_name
          define_method "#{resource_name}_signed_in?" do
            !!self.class.token_authorized_resources[resource_name]
          end

          define_method "current_#{resource_name}" do
            self.class.token_authorized_resources[resource_name]
          end

          define_method callback_name do
            authenticate_token_for! resource_name
          end

          protected callback_name
          before_action callback_name
        end
      end

    end

    module InstanceMethods

      protected

      def set_token_authorized_resource!
        token = request.headers[Touth.header_name]

        return unless token && Authenticator.valid_access_token?(token)

        resource = Authenticator.get_resource token
        resource_name = Touth.get_resource_name resource.class.name

        self.class.token_authorized_resources[resource_name] = resource
      end

      def authenticate_token_for!(resource_name)
        unless self.class.token_authorized_resources[resource_name]
          if Touth.allow_raise
            raise InvalidAccessTokenError, 'access token is not valid'
          else
            return unauthorized_token_error
          end
        end
      end

      def unauthorized_token_error
        render nothing: true, status: :unauthorized
        false
      end

    end
  end
end
