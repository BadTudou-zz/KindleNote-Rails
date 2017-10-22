require 'evernote_oauth'
require 'htmlentities'

class EvernoteController < ApplicationController
    def authorize
        callback_url = request.url.chomp("authorize").concat("callback")
        client = EvernoteOAuth::Client.new
        request_token = client.request_token(:oauth_callback => callback_url)
        session['request_token'] = request_token
        redirect_to request_token.authorize_url
    end

    def callback
        unless params['oauth_verifier'] || session['request_token']
                @last_error = "Content owner did not authorize the temporary credentials"
                return render :json => {
                    status:false,
                    message:@last_error
                }
        end
        session[:oauth_verifier] = params['oauth_verifier']
        
        begin
            consumer = EvernoteOAuth::Client
            request_token = OAuth::RequestToken.new(consumer, session[:request_token], session[:request_token_secret])
            session[:access_token] = session['request_token'].get_access_token(:oauth_verifier => session[:oauth_verifier])
        rescue => e
            @last_error = 'Error extracting access token'
            return render :json => {
                status: false,
                access_token: session[:access_token],
                message:@last_error
            }
        end

        render :json => {
                status:true,
                message:'evernote oauth success'
            }
    end
    def evernote
        unless session["access_token"]
            return redirect_to authorize_url
        end
        @evernote = EvernoteService.new(session["access_token"])
    end

    def user
        render :json => {
                status:true,
                message:evernote.user
            }
    end

    def store
        note = Note.find(params[:id])
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
                message:en_note
            }
    end
end
