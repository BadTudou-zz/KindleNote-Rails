class ClippingController < ApplicationController
    protect_from_forgery :except => [:upload]
    def index
        if logged_in?
            puts 'has login'
        else
            puts 'plaese login'
            flash.now[:danger] = 'Please login'
            
        end 
    end

    def new
    end

    def upload
        uploaded_io = params[:file]
        clipping_file_path = Rails.root.join('public', 'uploads', "#{UUID.new.generate}.txt")
        File.open(clipping_file_path, 'wb+') do |file|
            file.write(uploaded_io.read)
        end
        flash[:success] = "You must be logged in to access this section"
        ParseClippingToNoteJob.perform_later clipping_file_path.to_s, current_user
        redirect_to clipping_url
    end
end
