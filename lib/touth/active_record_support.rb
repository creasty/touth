module Touth
  module ActiveRecordSupport
    module ClassMethods

      def acts_as_token_authenticatable
        include Touth::ActiveRecordSupport::InstanceMethods
      end

    end

    module InstanceMethods
 
      def access_token(*args)
        Authenticator.issue_access_token self, *args
      end

      def valid_access_token?(token)
        Authenticator.get_model(token) == self
      end

    end
  end
end

ActiveSupport.on_load(:active_record) do
  extend Touth::ActiveRecordSupport::ClassMethods
end
