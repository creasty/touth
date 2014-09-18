module Touth
  module ActsAsTokenAuthenticatable

    def access_token(lifetime = Touth.access_token_lifetime)
      expires_at = Time.now.to_i + lifetime

      [access_token_id(expires_at), [expires_at].pack('V')].join.unpack('H*')[0]
    end

    def valid_access_token?(token)
      begin
        data = [token].pack 'H*'
        token_id, timestamp = data.unpack 'A32A*'
        expires_at = timestamp.unpack('V')[0]

        access_token_id(expires_at) == token_id && Time.now.to_i < expires_at
      rescue
        false
      end
    end

  private

    def access_token_id(expires_at)
      raw = [
        expires_at,
        self.class.name,
        self.id,
        self.send(Touth.password_field),
      ].join ':'

      Touth.digest raw
    end

  end
end
