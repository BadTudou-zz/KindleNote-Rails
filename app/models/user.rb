class User < ApplicationRecord
    attr_accessor :remeber_token, :evernote
    has_secure_password
    has_and_belongs_to_many :notes
    has_many :access_tokens
end
