class UsersController < ApplicationController
    load_and_authorize_resource :user

    protect_from_forgery :except => [:create]
    skip_before_action :require_login, only: [:new, :create]

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            log_in @user
            flash[:success] = "You has beed registerd"
            render :json => {
                status:true,
                message:'Login success',
                url:user_path(@user)
            }
        else
            flash[:warning] = "You has not registerd"
            render :json => {
                status:false,
                message:'Login error'
            }
        end
    end

    def show
        
    end

    def user_params
        params.require(:user).permit(:name, :email, :password)
    end
end
