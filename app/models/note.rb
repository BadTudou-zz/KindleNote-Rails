class Note < ApplicationRecord
    has_and_belongs_to_many :users
    attr_accessor :fragments
    # def initialize(title, author, cover_url='', rating=0)
    #     #@title, @author, @cover_url, @rating = title, author, cover_url, rating
    #     @title = title
    #     @author = author
    # end

    self.per_page = 10
end
