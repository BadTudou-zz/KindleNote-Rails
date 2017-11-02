set :stage, :production
set :rails_env, :production
set :deploy_to, "/usr/local/www/kindlenote"
set :repo_url, "git@github.com:BadTudou/KindleNote-Rails.git"
set :branch, ENV["PRODUCTION_BRANCH"]
server ENV["PRODUCTION_SERVER_IP"], user: ENV["PRODUCTION_DEPLOY_USER"], roles: %w{web app db}