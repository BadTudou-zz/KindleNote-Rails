class User < ApplicationRecord
    attr_accessor :remeber_token
    has_secure_password
    has_and_belongs_to_many :notes
end
