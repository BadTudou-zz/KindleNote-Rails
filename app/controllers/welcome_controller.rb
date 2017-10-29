class WelcomeController < ApplicationController
    skip_before_action :require_login, only: [:index]
    skip_authorization_check :only => [:index]
end
