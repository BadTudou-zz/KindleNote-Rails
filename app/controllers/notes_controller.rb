class NotesController < ApplicationController
    # before_action :set_current_account, only: [:show]

    # def set_current_account
    #     #  set @current_account from session data here
    #     class << Note
    #         attr_accessor :fragments
    #     end
    # end
    def index
        @notes = current_user.notes.paginate(:page => params[:page], :per_page => params[:page]).order('id DESC')
    end

    def show
        @note = Note.find(params[:id])
        @note.fragments = Fragment.where(user_id: current_user.id, note_id: params[:id])
    end
end
