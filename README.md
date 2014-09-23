Touth
=====

Secure and simple token based authentication for Rails.

- No extra dependencies
- No migrations necessary
- Store-less access token verification
- Flexible lifetime


Getting started
---------------

Touth works with Rails 3.x and 4.x. Add this line to Gemfile:

```ruby
gem 'touth'
```

### Model

```ruby
class UserAccount < ActiveRecord::Base

  acts_as_token_authenticatable

end
```

### Controller

```ruby
class ApplicationController < ActionController::Base

  token_authentication_for :user_account

end
```

### Helper methods

Checking if a user is signed in, and getting the current signed-in user, the following Devise-like helpers is available:

- `user_account_signed_in?`
- `current_user_account`

### Hooks

- `authenticate_user_account!`


Usage
-----

### Access token generation

```ruby
user_account = UserAccount.first


# create access token
t1 = user_account.access_token
#=> "0c63df99a514563a274377bb5f382c3be3bc0ff75b3758be5cd145984134d73608fe77339f7f38abf71eec38ba6800c0e2e4af08227f251b0f81163878aa25ab04085b086310557365724163636f756e7469066c2b07cc536b54"


# create token expires in 20 secounds
t2 = user_account.access_token 20
#=> "622bf3498d0c6d846f31f8bd486cbedf3dce0076661d98111231726b35709d3f6a46a419b4799fb84b94258025eafa304baf8196877c281145a434e6b859b90504085b086310557365724163636f756e7469066c2b07e1536b54"

user_account.valid_access_token? t2  #=> true
sleep 20
user_account.valid_access_token? t2  #=> false
```

### Authentication by request headers

```
X-Access-Token: 2a20d42585159a9f1c9564afd051d48e2209af5e18d83c9685de1ae0df66c2b76c2bc7633e4b14748f1cf94b09e94d1a33804b1e74dad9d02d231b12e6c840b504085b086310557365724163636f756e7469066c2b0737546b54
```

### Invalidation

**1. Invalidate all old access token**

Change `client_secret_key` in initializer.

**2. Invalidate all old access token of specific user**

Owner (an user) can do with changing his password.


Configuation
------------

Touth can be customized with an initializer in `config/initializers/touth.rb`.

```ruby
Touth.setup do |config|

  # Default lifetime of access token.
  config.access_token_lifetime = 60.days

  # Secret key is used for verifying the integrity of access token.
  # If you change this key, all old access token will become invalid.
  # You can use rake secret or SecureRandom.hex(64) to generate one.
  config.client_secret_key = ''

  # Password field in your model.
  # Owner can invalidate all old access token by changing owner's password.
  # :encrypted_password will work nice with devise model.
  config.password_field = :encrypted_password

  # Header name
  config.header_name = 'X-Access-Token'

  # Allow raise access token errors.
  # If set to true, you can use `rescue_from` method in your controller.
  # Otherwise, it will render a blank page with unauthorized status-code.
  config.allow_raise = false

end
```


Contributing
------------

Contributions are always welcome!


License
-------

This project is copyright by [Creasty](http://www.creasty.com), released under the MIT lisence.  
See `LICENSE` file for details.
