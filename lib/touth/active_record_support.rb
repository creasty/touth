module Touth
  module ActiveRecordSupport

    module ClassMethods

      def acts_as_token_authenticatable
        include Touth::ActsAsTokenAuthenticatable
      end

    end

  end
end
