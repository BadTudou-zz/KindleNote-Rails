class EvernoteService
    def initialize(access_token)
        @access_token = access_token
    end

    def client
        client ||= EvernoteOAuth::Client.new(token: @access_token.token)
    end

    def user_store
        user_store ||= client.user_store
    end
 
    def note_store
        note_store ||= client.note_store
    end

    def user
        user_store.getUser        
    end

    def make_note(note_title, note_body, parent_notebook=nil)
        n_body = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
        n_body += "<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\">"
        n_body += "<en-note>#{note_body}</en-note>"

        ## Create note object
        our_note = Evernote::EDAM::Type::Note.new
        our_note.title = note_title
        our_note.content = n_body

        ## parent_notebook is optional; if omitted, default notebook is used
        if parent_notebook && parent_notebook.guid
            our_note.notebookGuid = parent_notebook.guid
        end

        ## Attempt to create note in Evernote account
        #begin
            note = note_store.createNote(our_note)
        # rescue Evernote::EDAM::Error::EDAMUserException => edue
        #     ## Something was wrong with the note data
        #     ## See EDAMErrorCode enumeration for error code explanation
        #     ## http://dev.evernote.com/documentation/reference/Errors.html#Enum_EDAMErrorCode
        #     puts "EDAMUserException: #{edue}"
        # rescue Evernote::EDAM::Error::EDAMNotFoundException => ednfe
        #     ## Parent Notebook GUID doesn't correspond to an actual notebook
        #     puts "EDAMNotFoundException: Invalid parent notebook GUID"
        # end

        ## Return created note object
        end
end