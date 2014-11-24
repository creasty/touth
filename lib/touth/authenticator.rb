module Touth
  module Authenticator

  module_function

    def issue_access_token(resource, lifetime = Touth.access_token_lifetime)
      expires_at = Time.now.to_i + lifetime

      data = Marshal.dump([
        resource.class,
        resource.id,
        expires_at,
      ])

      data_sign = Touth.digest data
      data_key = gen_data_key resource, data_sign

      [
        data_sign,
        data_key,
        data,
      ].join.unpack('H*')[0]
    end

    def valid_access_token?(token)
      !!get_resource(token)
    end

    def get_resource(token)
      @access_token_data_cache ||= {}
      resource = @access_token_data_cache[token]

      return resource if resource

      @access_token_data_cache[token] = nil

      begin
        data_sign, data_key, data = [token].pack('H*').unpack 'A32A32A*'

        if data_sign == Touth.digest(data)
          resource_class, id, expires_at = Marshal.load data

          resource = resource_class.find id

          if gen_data_key(resource, data_sign) == data_key && Time.now.to_i < expires_at
            @access_token_data_cache[token] = resource
          end
        end
      rescue
        nil
      end
    end

    def gen_data_key(resource, data_sign)
      Touth.digest [data_sign, resource.send(Touth.password_field)].join
    end

  end
end
