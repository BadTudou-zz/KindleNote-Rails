class Note < ApplicationRecord
    has_and_belongs_to_many :users
    public
    # def initialize(title, author, cover_url='', rating=0)
    #     #@title, @author, @cover_url, @rating = title, author, cover_url, rating
    #     @title = title
    #     @author = author
    # end
end
