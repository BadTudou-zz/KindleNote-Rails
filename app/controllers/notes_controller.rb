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

    def update
    end

    def destroy
        flash[:success] = "The note has been deleted successfully！" if Note.destroy(params[:id])
        redirect_to user_notes_path(current_user.id)
    end

    def export_to_markdown
        content = export_markdown(params[:note_id])
        markdown_file_path = Rails.root.join('public', 'markdown', "#{UUID.new.generate}.md")
        File.open(markdown_file_path, 'wb+') do |file|
            file.write(content)
        end
        download(markdown_file_path, @note.title+".md")
        

    end

    def download_markdown
        file_path = params["file"]
        markdown_file_path = Rails.root.join('public', 'markdown', file_path+'.md')
        download(markdown_file_path)
    end


    def export_to_evernote
        en_note = export_evernote(params[:note_id])
        render :json => {
                status:true,
                message:en_note.guid
            }
    end

    def batch
        note_ids = params[:notes]
        case params[:operate]
        when 'evernote'
            count_ennote = 0
            note_ids.each do |note_id|
                count_ennote += 1 if export_evernote(note_id)
            end
            message = "成功导入#{count_ennote}条笔记到印象笔记"
        when 'markdown'
            count_ennote = 0
            markdown_content = ''
            note_ids.each do |note_id|
                 markdown_content += export_markdown(note_id)
                 count_ennote += 1
            end
            file_name = "#{UUID.new.generate}.md"
            markdown_file_path = Rails.root.join('public', 'markdown', file_name)
            File.open(markdown_file_path, 'wb+') do |file|
                file.write(markdown_content)
            end
            url =  user_download_url(current_user.id, file_name.to_s)
            message = "成功导入#{count_ennote}条笔记到Markdown"
        when 'delete'
            count_note = Note.delete(note_ids)
            message = "成功删除#{count_note}条笔记"
        end

        render :json => {
                status:true,
                url:url,
                message:message
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

        def export_markdown(note_id)
            @note = Note.find(note_id)
            @note.fragments = Fragment.where(user_id: current_user.id, note_id: note_id)
            title = "# #{@note.title}"
            author = "**#{@note.author}**"
            content = ''
            @note.fragments.each do |fragment|
                content += "* #{fragment[:content]} \n"
            end
            return title+"\n"+author+"\n"+content
        end

        def export_evernote(note_id)
            note = Note.find(note_id)
            note.fragments = Fragment.where(user_id: current_user.id, note_id: note_id)
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
        end

        def download(file_path, file_name="KindleNote-#{DateTime.now.to_date.to_s}.md")
            send_file(
                file_path,
                filename: file_name,
                type: "text/markdown"
            )
        end

end
