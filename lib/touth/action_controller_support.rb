module Touth
  module ActionControllerSupport
    module ClassMethods

      mattr_accessor :access_token_resources

      def token_authentication_for(resource_name)
        resource_name = Touth.get_resource_name resource_name

        self.access_token_resources ||= {}

        define_method "#{resource_name}_signed_in?" do
          !!self.class.access_token_resources[resource_name]
        end

        define_method "current_#{resource_name}" do
          self.class.access_token_resources[resource_name]
        end

        callback_name = "authenticate_#{resource_name}!".to_sym

        unless method_defined? callback_name
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

      def authenticate_token_for!(resource_name)
        if Touth.allow_raise
          set_token_authorized_model resource_name
        else
          begin
            set_token_authorized_model resource_name
          rescue
            return unauthorized_token_error
          end
        end
      end

      def set_token_authorized_model(resource_name)
        resource_name = Touth.get_resource_name resource_name

        token = request.headers[Touth.header_name]

        unless token && Authenticator.valid_access_token?(token)
          raise InvalidAccessTokenError, 'access token is not valid'
        end

        model = Authenticator.get_model token
        model_name = Touth.get_resource_name model.class.name

        unless model_name == resource_name
          raise ResourceConflictError, 'attempted %s to login, expected %s' % [model, resource_name]
        end

        self.class.access_token_resources[model_name] = model
      end

      def unauthorized_token_error
        render nothing: true, status: :unauthorized
        false
      end

    end
  end
end
