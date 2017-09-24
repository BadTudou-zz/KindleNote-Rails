class UserController < ApplicationController
    protect_from_forgery :except => [:create]

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            render :json => 'register success'
        else
            render :json => @user.errors
        end
    end

    def show
    end

    def user_params
        params.require(:user).permit(:name, :email, :password)
    end
end
