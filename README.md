Touth
=====

Secure and simple token based authentication for Rails.

No dependencies. No migration necessary. Session-less.


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

user_account.access_token
```

### Authentication by request headers

```
X-Auth-ID: 1
X-Auth-Token: 9619feb4b8d54352ae07588d011da48385c8c4f072ab889d3996d127ad2142fc6213d553
```


Configuation
------------

Touth can be customized with an initializer in `config/initializers/touth.rb`.

```ruby
Touth.setup do |config|
  config.access_token_lifetime = 60.days
  config.client_secret_key     = ''  # use SecureRandom.hex(64) to generate one
  config.password_field        = :encrypted_password  # works nice with devise
end
```


Contributing
------------

Contributions are always welcome!

### Bug reports

1. Ensure the bug can be reproduced on the latest master.
2. Check it's not a duplicate.
3. Raise an issue.


### Pull requests

1. Fork the repository.
2. Create a branch.
6. Create a new pull request.


License
-------

This project is copyright by [Creasty](http://www.creasty.com), released under the MIT lisence.  
See `LICENSE` file for details.

