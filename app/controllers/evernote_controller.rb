require 'evernote_oauth'
require 'htmlentities'

class EvernoteController < ApplicationController
    skip_before_action :require_login, only: [:authorize, :callback]
    load_and_authorize_resource :user

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
            session[:access_token_expires] = session[:access_token].params['edam_expires']

            user_store = EvernoteOAuth::Client.new(token: session[:access_token].token).user_store
            en_user = user_store.getUser

            access_token_evernote = AccessToken.find_by(name: 'evernote', openid: en_user.id)
            if !access_token_evernote.nil?
                user = User.find(access_token_evernote.user_id)
                log_in user
                return redirect_to user_notes_path(user)
            end

            if !logged_in?
                new_user = User.create(name: en_user.username, password_digest: 'kindlenote')
                new_user.access_tokens.create(user_id: new_user.id, name: 'evernote', access_token: session[:access_token].token, openid: en_user.id, expires: nil, revoked:true )
                log_in new_user
                return redirect_to user_notes_path(new_user)
            end
            access_token_evernote.update(user_id: current_user.id, name: 'evernote', access_token: session[:access_token].token, openid: en_user.id, expires: Time.at(session[:access_token_expires].to_i / 1000), revoked:true )
            
        rescue => e
            return render :json => {
                status: false,
                access_token: session[:access_token],
                message:e
            }
        end

        render :json => {
                status:true,
                message:'evernote oauth success',
                expires: Time.at(session[:access_token_expires].to_i / 1000),
                evernote: en_user
            }
    end

    

    

    def user
        render :json => {
                status:true,
                message:evernote.user
            }
    end

end
