module Touth
  class Middleware

    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call env
    ensure
      Store.clear!
    end

  end
end
