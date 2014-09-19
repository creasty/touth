module Touth
  module Authenticator

  module_function

    def issue_access_token(model, lifetime = Touth.access_token_lifetime)
      expires_at = Time.now.to_i + lifetime

      data = Marshal.dump([
        model.class,
        model.id,
        expires_at,
      ])

      data_sign = Touth.digest data
      data_key = gen_data_key model, data_sign

      [
        data_sign,
        data_key,
        data,
      ].join.unpack('H*')[0]
    end

    def valid_access_token?(token)
      !!get_model(token)
    end

    def get_model(token)
      @access_token_data_cache ||= {}
      model = @access_token_data_cache[token]

      return model if model

      begin
        data_sign, data_key, data = [token].pack('H*').unpack 'A32A32A*'

        if data_sign == Touth.digest(data)
          model_class, id, expires_at = Marshal.load data

          model = model_class.find id

          if gen_data_key(model, data_sign) == data_key && Time.now.to_i < expires_at
            @access_token_data_cache[token] = model
          end
        end
      rescue
        nil
      end
    end

    def gen_data_key(model, data_sign)
      Touth.digest [data_sign, model.send(Touth.password_field)].join
    end

  end
end
