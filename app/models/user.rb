class User < ApplicationRecord
    attr_accessor :remeber_token
    has_secure_password
end
