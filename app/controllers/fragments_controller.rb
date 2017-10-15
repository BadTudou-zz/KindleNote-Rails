class FragmentsController < ApplicationController
    
    def show
        @fragment = Fragment.find(params[:id])
    end

    def destroy
        Fragment.destroy(params[:id])
    end
end
