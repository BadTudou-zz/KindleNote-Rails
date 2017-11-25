class SessionsController < ApplicationController
    protect_from_forgery :except => [:create]
    skip_before_action :require_login, only: [:new, :create]
    skip_authorization_check :only => [:new, :create, :destroy]
    
    def create
        user = User.find_by(email: params[:user][:email])
        if user && user.authenticate(params[:user][:password])
            cookies.encrypted[:user_id] = user.id
            log_in user
            render :json => {
                status:true,
                message:'Login success',
                url: back_or_default_url(user_notes_path(user))
            }
        else
            flash[:warning] = 'email or passowrd wrong'
            render :json => {
                status:false,
                message:'Login error'
            }
        end
    end

    def destroy
        log_out
        redirect_to root_url
    end

    def back_or_default_url(default)
        return_to = session[:return_to] || default
        session[:return_to] = nil
        return_to
    end
end
