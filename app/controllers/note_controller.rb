class NoteController < ApplicationController
  def index
    @notes = Note.all
  end
end
