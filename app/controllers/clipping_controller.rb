class ClippingController < ApplicationController
    protect_from_forgery :except => [:upload]
    def index
    end

    def new
    end

    def upload
        uploaded_io = params[:file]
        File.open(Rails.root.join('public', 'uploads', "#{UUID.new.generate}.txt"), 'wb+') do |file|
            file.write(uploaded_io.read)
        end
        puts 'upload file success'
    end
end
