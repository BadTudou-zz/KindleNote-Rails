class NotesController < ApplicationController
    load_and_authorize_resource :user
    load_and_authorize_resource :note, :through => :user
    before_action :set_current_account, only: [:show]
    before_action :check_access_token, only: [:export_to_evernote]

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

    def export_to_markdown
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

    def export_to_evernote
        note = Note.find(params[:note_id])
        note.fragments = Fragment.where(user_id: current_user.id, note_id: params[:id])
        content = ''
        note.fragments.each do |fragment|
            content += (HTMLEntities.new.encode(fragment[:content].force_encoding('UTF-8'))+ "<br/>")
        end

        begin
            en_note = evernote.make_note(note[:title], content)
        rescue Evernote::EDAM::Error::EDAMUserException => edue
            p edue
            return redirect_to authorize_url
        end

        render :json => {
                status:true,
                message:en_note.guid
            }
    end

    private
        def evernote
            consumer = EvernoteOAuth::Client
            access_token = current_user.access_tokens.where(name: 'evernote').first
            EvernoteService.new(access_token.access_token)
        
        end
        def check_access_token
            unless current_user.access_tokens.where(name: 'evernote').first
                redirect_to evernote_authorize_url
            end
        end
end
