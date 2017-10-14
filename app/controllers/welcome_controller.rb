class WelcomeController < ApplicationController
    skip_before_action :require_login, only: [:new, :create]
    
    def index
        return puts 'hello'
    end
end
