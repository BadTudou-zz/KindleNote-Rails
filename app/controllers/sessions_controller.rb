class SessionsController < ApplicationController
    protect_from_forgery :except => [:create]
    
    def new
    end

    def create
        user = User.find_by(email: params[:user][:email])
        if user && user.authenticate(params[:user][:password])
            log_in user
            render :json => {
                status:true,
                message:'Login success',
                url:'/user/show'
            }
        else
            render :json => {
                status:false,
                message:'Login error'
            }
        end
    end
end
