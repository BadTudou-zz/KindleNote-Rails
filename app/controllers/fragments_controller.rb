class FragmentsController < ApplicationController
    
    def show
        @fragment = Fragment.find(params[:id])
    end
end
