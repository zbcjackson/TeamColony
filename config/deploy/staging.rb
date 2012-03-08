role :web, "10.86.65.53"                          # Your HTTP server, Apache/etc
role :app, "10.86.65.53"                          # This may be the same as your `Web` server
role :db,  "10.86.65.53", :primary => true # This is where Rails migrations will run
set :env, 'test'