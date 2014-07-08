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

- `authenticate_entity_from_token!`

### Fallbacks

- `token_authentication_error!(type)`


Usage
-----

### Access token generation

```ruby
user_account = UserAccount.first


# create access token for default lifetime
t1 = user_account.access_token  #=> "9619feb4b8d54352ae07588d011da48385c8c4f072ab889d3996d127ad2142fc6213d553"


# create token expires in 20 secounds
t2 = user_account.access_token 20  #=> "ad60fa5bb2d05e72ac943c6d409e18e6cc24c15eae9833f66c8aab391241475fe2bd0954"

user_account.valid_access_token? t2  #=> true
sleep 20
user_account.valid_access_token? t2  #=> false
```

### Authentication by request headers

```
X-Auth-ID: 1
X-Auth-Token: 9619feb4b8d54352ae07588d011da48385c8c4f072ab889d3996d127ad2142fc6213d553
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

end
```


Contributing
------------

Contributions are always welcome!

### Bug reports

1. Ensure the bug can be reproduced on the latest master.
1. Check it's not a duplicate.
1. Raise an issue.


### Pull requests

1. Fork the repository.
1. Create a branch.
1. Create a new pull request.


License
-------

This project is copyright by [Creasty](http://www.creasty.com), released under the MIT lisence.  
See `LICENSE` file for details.

