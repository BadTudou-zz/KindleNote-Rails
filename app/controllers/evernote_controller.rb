require 'evernote_oauth'
require 'htmlentities'

class EvernoteController < ApplicationController
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
            current_user.access_tokens.create(user_id: current_user.id, name: 'evernote', access_token: session[:access_token].token, expires: Time.at(session[:access_token_expires].to_i / 1000), revoked:true )
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
                expires: Time.at(session[:access_token_expires].to_i / 1000)
            }
    end

    

    

    def user
        render :json => {
                status:true,
                message:evernote.user
            }
    end

end
