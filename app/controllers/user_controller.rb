class UserController < ApplicationController
    def new
        @user = User.new
    end

    def create
        @user = User.new(params[:user])
        if @user.save
            puts 'register success'
        else
            puts 'register error'
        end
    end
end
