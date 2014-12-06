module Touth
  module Store

    ACCESS_TOKENS_STORE_KEY = :touth_access_tokens_store
    CURRENTS_STORE_KEY      = :touth_currents_store

    class << self

      def access_tokens
        Thread.current[ACCESS_TOKENS_STORE_KEY] ||= {}
      end

      def currents
        Thread.current[ACCESS_CURRENTS_STORE_KEY] ||= {}
      end

      def clear!
        Thread.current[ACCESS_TOKENS_STORE_KEY] = {}
        Thread.current[ACCESS_CURRENTS_STORE_KEY] = {}
      end

    end
  end
end
