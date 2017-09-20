class ClippingController < ApplicationController
    protect_from_forgery :except => [:upload]
    def index
    end

    def new
    end

    def upload
        uploaded_io = params[:file]
        clipping_file_path = Rails.root.join('public', 'uploads', "#{UUID.new.generate}.txt")
        File.open(clipping_file_path, 'wb+') do |file|
            file.write(uploaded_io.read)
        end
        puts 'upload file success'
        ParseClippingToNoteJob.perform_later clipping_file_path.to_s
    end
end
