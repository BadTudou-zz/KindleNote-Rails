class NotesController < ApplicationController
    load_and_authorize_resource :user
    load_and_authorize_resource :note, :through => :user
    before_action :set_current_account, only: [:show]

    def set_current_account
        #  set @current_account from session data here
        class << Note
            attr_accessor :fragments
        end
    end

    def index
        @notes = current_user.notes.paginate(:page => params[:page], :per_page => 8).order('id DESC')
    end

    def show
        @note = Note.find(params[:id])
        @note.fragments = Fragment.where(user_id: current_user.id, note_id: params[:id])
    end

    def markdown
        @note = Note.find(params[:note_id])
        @note.fragments = Fragment.where(user_id: current_user.id, note_id: params[:note_id])
        title = "# #{@note.title}"
        author = "**#{@note.author}**"
        content = ''
        @note.fragments.each do |fragment|
            content += "* #{fragment[:content]} \n"
        end

        markdown_file_path = Rails.root.join('public', 'markdown', "#{UUID.new.generate}.md")
        File.open(markdown_file_path, 'wb+') do |file|
            file.write(title+"\n"+author+"\n"+content)
        end
        
        send_file(
                markdown_file_path,
                filename: @note.title+".md",
                type: "text/markdown"
            )

    end
end
