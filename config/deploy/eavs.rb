role :app, %w{alg@noizeramp.com}
role :web, %w{alg@noizeramp.com}
role :db,  %w{alg@noizeramp.com}

set :deploy_to, '/home/alg/sites/eavsweb.trustthevote.org'
set :rails_env, 'production'

# Setting server-side version explicitly
set :rvm_ruby_version, '2.1.3'
