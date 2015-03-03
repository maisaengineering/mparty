worker_processes Integer(ENV["WEB_CONCURRENCY"] || 2)
timeout 60
preload_app true

# run_sidekiq_in_this_thread = true
# @sidekiq_pid = nil

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!

  # if run_sidekiq_in_this_thread
  #   p "starting Sidekiq w/ unicorn"
  #   @sidekiq_pid ||= spawn("bundle exec sidekiq")
  #   Rails.logger.info('Spawned sidekiq #{@sidekiq_pid}')
  # end
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection
end