class NoteController < ApplicationController
  def index
    @notes = current_user.notes
  end

  def show
    @note = Note.find(params[:id])
    @fragments = Fragment.where(user_id: current_user.id, note_id: params[:id])
  end
end
