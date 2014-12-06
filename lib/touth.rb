require 'active_support'

require_relative 'touth/version'
require_relative 'touth/store'
require_relative 'touth/authenticator'
require_relative 'touth/active_record_support'
require_relative 'touth/action_controller_support'
require_relative 'touth/middleware'
require_relative 'touth/railtie' if defined? Rails


#  Touth
#-----------------------------------------------
module Touth

  class Configuration

    attr_accessor :access_token_lifetime,
      :client_secret_key,
      :password_field,
      :header_name,
      :allow_raise

    def initialize
      @access_token_lifetime = 60 * (24 * 60 * 60)  # 60 days
      @client_secret_key     = ''  # use SecureRandom.hex(64) to generate one
      @password_field        = :encrypted_password
      @header_name           = 'X-Access-Token'
      @allow_raise           = false
    end

  end

  class InvalidAccessTokenError < StandardError; end

  class << self

    def setup
      @config ||= Configuration.new
      yield @config if block_given?
    end

    def digest(data)
      @digest_method ||= OpenSSL::Digest.new 'sha256'
      OpenSSL::HMAC.digest @digest_method, self.client_secret_key, data
    end

    def get_resource_name(name)
      name.to_s.gsub('::', '_').underscore
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


#  Load
#-----------------------------------------------
ActiveSupport.on_load(:action_controller) do
  extend Touth::ActionControllerSupport::ClassMethods
  include Touth::ActionControllerSupport::InstanceMethods
end

ActiveSupport.on_load(:active_record) do
  extend Touth::ActiveRecordSupport::ClassMethods
end
