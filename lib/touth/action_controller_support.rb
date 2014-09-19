module Touth
  module ActionControllerSupport
    module ClassMethods

      mattr_accessor :access_token_resources

      def token_authentication_for(resource_name)
        resource_name = resource_name.to_s
        name = resource_name.gsub('::', '_').underscore

        unless self.access_token_resources
          self.access_token_resources = {}
          before_action :authenticate_token!
        end

        define_method "#{name}_signed_in?" do
          !!self.class.access_token_resources[resource_name]
        end

        define_method "current_#{name}" do
          self.class.access_token_resources[resource_name]
        end
      end

    end

    module InstanceMethods

    protected

      def authenticate_token!
        token = request.headers[Touth.header_name]

        unless token && Authenticator.valid_access_token?(token)
          render nothing: true, status: :unauthorized
          return false
        end

        model = Authenticator.get_model token
        self.class.access_token_resources[model.class.name] = model
      end

    end
  end
end
