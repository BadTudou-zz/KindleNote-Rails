#load 'deploy'
# Uncomment if you are using Rails' asset pipeline
    # load 'deploy/assets'
#load 'config/deploy' # remove this line to skip loading any of the default tasks
require "capistrano/setup"

require "capistrano/deploy"

require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

require "capistrano/rbenv"
require "capistrano/bundler"
require "capistrano/rails/assets"
require "capistrano/rails/migrations"

require "capistrano/puma"
install_plugin Capistrano::Puma

Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }