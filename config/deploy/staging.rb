role :web, "beta.iagile.me"                          # Your HTTP server, Apache/etc
role :app, "beta.iagile.me"                          # This may be the same as your `Web` server
role :db,  "beta.iagile.me", :primary => true # This is where Rails migrations will run
set :rails_env, 'test'