module Touth
  class Railtie < ::Rails::Railtie
    initializer 'request_store.insert_middleware' do |app|
      if ActionDispatch.const_defined? :RequestId
        app.config.middleware.insert_after ActionDispatch::RequestId, Touth::Middleware
      else
        app.config.middleware.insert_after Rack::MethodOverride, Touth::Middleware
      end
    end
  end
end
