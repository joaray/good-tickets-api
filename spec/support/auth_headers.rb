require 'devise/jwt/test_helpers'

def auth_headers(user)
  headers = { 'Accept' => 'application/json' }
  Devise::JWT::TestHelpers.auth_headers(headers, user)
end
