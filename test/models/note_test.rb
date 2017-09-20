require 'test_helper'

class NoteTest < ActiveSupport::TestCase

    test 'create' do 
        note = Note.new
        note.title = 'title'
        note.author = 'author'
        assert note.save
    end
end
