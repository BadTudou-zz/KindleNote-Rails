set :stage, :development
set :rails_env, :development
set :deploy_to, "/usr/local/www/kindlenote"
set :repo_url, "git@github.com:BadTudou/KindleNote-Rails.git"
set :branch, 'develop'
server ENV["PRODUCTION_SERVER_IP"], user: ENV["PRODUCTION_DEPLOY_USER"], roles: %w{web app db}