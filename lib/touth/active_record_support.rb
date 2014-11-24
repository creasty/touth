module Touth
  module ActiveRecordSupport
    module ClassMethods

      def has_access_token
        include Touth::ActiveRecordSupport::InstanceMethods
      end

    end

    module InstanceMethods
 
      def access_token(*args)
        Authenticator.issue_access_token self, *args
      end

      def valid_access_token?(token)
        Authenticator.get_resource(token) == self
      end

    end
  end
end
