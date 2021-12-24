
# max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
# min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
# threads min_threads_count, max_threads_count

# port        ENV.fetch("PORT") { 3000 }


# environment ENV.fetch("RAILS_ENV") { "development" }

# pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }
# plugin :tmp_restart



########## puma用設定 ##########

workers Integer(ENV.fetch("WEB_CONCURRENCY") { 2 })

max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

preload_app!

rackup      DefaultRackup
port        ENV.fetch("PORT") { 3000 }
environment ENV.fetch("RAILS_ENV") { "development" }

on_worker_boot do
  ActiveRecord::Base.establish_connection
end