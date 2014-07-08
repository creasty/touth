require 'active_support'

require_relative 'touth/engine' if defined? Rails


#  Touth
#-----------------------------------------------
module Touth

  extend ActiveSupport::Autoload

  autoload :ActsAsTokenAuthenticatable
  autoload :ActiveRecordSupport
  autoload :ActionControllerSupport
  autoload :VERSION

  class Configuration

    attr_accessor :access_token_lifetime,
      :client_secret_key,
      :password_field

    def initialize
      @access_token_lifetime = 60 * (24 * 60 * 60)  # 60 days
      @client_secret_key     = ''  # use SecureRandom.hex(64) to generate one
      @password_field        = :encrypted_password
    end

  end

  class << self

    def setup
      @config ||= Configuration.new
      yield @config if block_given?
    end

    def digest(data)
      @digest_method ||= OpenSSL::Digest.new 'sha256'
      OpenSSL::HMAC.digest @digest_method, self.client_secret_key, data
    end

    def method_missing(method_name, *args, &block)
      if @config.respond_to? method_name
        @config.send method_name, *args, &block
      else
        super
      end
    end

    def respond_to?(method_name, include_private = false)
      @config.respond_to? method_name
    end

  end

end


#  Setup
#-----------------------------------------------
Touth.setup


#  Include
#-----------------------------------------------
ActiveSupport.on_load(:active_record) do
  extend Touth::ActiveRecordSupport::ClassMethods
end
ActiveSupport.on_load(:action_controller) do
  extend Touth::ActionControllerSupport::ClassMethods
  include Touth::ActionControllerSupport::InstanceMethods
end

